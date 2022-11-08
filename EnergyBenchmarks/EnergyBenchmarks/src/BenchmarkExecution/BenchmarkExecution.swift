//
//  BenchmarkExecutor.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 10/07/21.
//

import Foundation

typealias BenchmarkExecutorEmptyBlock = ()->()
typealias BenchmarkExecutorResultBlock = (Benchmark, BenchmarkResult)->()

class BenchmarkExecution {
    
    var benchmark:Benchmark
    
    let powerControl = PowerControl()
    
    init(_ benchmark:Benchmark) {
        self.benchmark = benchmark
    }
    
    func shortDelay(_ execute:@escaping BenchmarkExecutorEmptyBlock) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            execute()
        }
    }
    
    private func setup(onComplete:@escaping BenchmarkExecutorEmptyBlock) {
        powerControl.reduceBrightness()
        BatteryMonitor.shared.startMonitoring()
        
        shortDelay { [weak self] in
            // We want to make sure the device is fully charged
            // and disconnected before each test
            self?.powerControl.connect {
                self?.powerControl.fullyRecharge {
//                    assert(BatteryMonitor.shared.state == .full)
//                    assert(BatteryMonitor.shared.level == 1.0)
                    onComplete()
                }
            }
        }
    }
    
    
    func execute(onCompletion:@escaping BenchmarkExecutorResultBlock) {
        eblog?("####### PREPARING BENCHMARK: \(benchmark.category) \(benchmark.identifier)")
        setup { [weak self] in
            self!.powerControl.disconnect {
//                assert(BatteryMonitor.shared.state == .unplugged)
//                assert(BatteryMonitor.shared.level == 1.0)
                
                DispatchQueue.global().async {
                    let start = DispatchTime.now()
                    eblog?("####### EXECUTING BENCHMARK: \(self!.benchmark.category) \(self!.benchmark.identifier)")
                    self!.benchmark.execute()
                    eblog?("####### FINISHING BENCHMARK: \(self!.benchmark.category) \(self!.benchmark.identifier)")
                    self!.teardown(start) { benchmark,result in
                        onCompletion(benchmark,result)
                    }
                };
            }
        }
        
    }
    
    private func teardown(_ start:DispatchTime, onCompletion:@escaping BenchmarkExecutorResultBlock) {
        let battery = 1.0 - BatteryMonitor.shared.level
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
        
        self.powerControl.connect { [weak self] in
            BatteryMonitor.shared.stopMonitoring()
            self!.shortDelay {
                onCompletion(self!.benchmark,result)
            }
        }
    }
}
