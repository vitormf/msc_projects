//
//  BenchmarkExecutor.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 10/07/21.
//

import Foundation

typealias BenchmarkExecutorEmptyBlock = ()->()
typealias BenchmarkExecutorResultBlock = (Benchmark, BenchmarkResult)->()

private func shortDelay(_ execute:@escaping BenchmarkExecutorEmptyBlock) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        execute()
    }
}

class BenchmarkExecution {
    
    var benchmark:Benchmark
    
    let powerControl = PowerControl.shared
    
    init(_ benchmark:Benchmark) {
        self.benchmark = benchmark
    }
    

    
    private func setup(onComplete:@escaping BenchmarkExecutorEmptyBlock) {
        powerControl.reduceBrightness()
        BatteryMonitor.shared.startMonitoring()
        self.benchmark.setup()
        
        shortDelay { [weak self] in
            // We want to make sure the device is fully charged
            // and disconnected before each test
            if (BatteryMonitor.shared.level > PowerControl.START_BATTERY_LEVEL) {
                self?.powerControl.discharge {
                    onComplete()
                }
            } else {
                self?.powerControl.recharge {
                    self?.powerControl.discharge {
                        onComplete()
                    }
                }
            }
        }
    }
    
    
    func execute(onCompletion:@escaping BenchmarkExecutorResultBlock) {
        eblog?("####### PREPARING BENCHMARK: \(benchmark.category) \(benchmark.identifier)")
        ebspeak("PREPARING BENCHMARK: \(benchmark.category) \(benchmark.identifier)")
        setup { [weak self] in
            guard let self = self else { return }
            self.powerControl.disconnect {
//                assert(BatteryMonitor.shared.state == .unplugged)
//                assert(BatteryMonitor.shared.level == 1.0)
                
                DispatchQueue.global().async {
                    let start = DispatchTime.now()
                    eblog?("####### EXECUTING BENCHMARK: \(self.benchmark.category) \(self.benchmark.identifier)")
                    ebspeak("EXECUTING BENCHMARK: \(self.benchmark.category) \(self.benchmark.identifier)")
                    self.benchmark.execute {
                        eblog?("####### FINISHING BENCHMARK: \(self.benchmark.category) \(self.benchmark.identifier)")
                        ebspeak("FINISHING BENCHMARK: \(self.benchmark.category) \(self.benchmark.identifier)")
                        self.teardown(start) { benchmark,result in
                            onCompletion(benchmark,result)
                        }
                    }
                };
            }
        }
        
    }
    
    private func teardown(_ start:DispatchTime, onCompletion:@escaping BenchmarkExecutorResultBlock) {
        let battery = PowerControl.START_BATTERY_LEVEL - BatteryMonitor.shared.level
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
//        assert(BatteryMonitor.shared.state == .unplugged)
        self.benchmark.validate()
        
        
        let result = BenchmarkResult(
            category: self.benchmark.category,
            identifier: self.benchmark.identifier,
            info: self.benchmark.info,
            battery:UInt(round(battery*100)),
            duration: timeInterval
        )


        let benchmark = self.benchmark
        self.powerControl.connect {
            BatteryMonitor.shared.stopMonitoring()
            shortDelay {
                onCompletion(benchmark,result)
            }
        }
    }
}
