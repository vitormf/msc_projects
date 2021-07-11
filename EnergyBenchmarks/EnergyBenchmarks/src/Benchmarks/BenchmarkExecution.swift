//
//  BenchmarkExecutor.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 10/07/21.
//

import Foundation

typealias BenchmarkExecutorBlock = ()->()

class BenchmarkExecution {
    
    var benchmark:Benchmark
    
    let powerControl = PowerControl()
    
    init(_ benchmark:Benchmark) {
        self.benchmark = benchmark
    }
    
    func shortDelay(_ execute:@escaping BenchmarkExecutorBlock) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            execute()
        }
    }
    
    private func setup(onComplete:@escaping BenchmarkExecutorBlock) {
        log("### preparing test: \(benchmark.category) \(benchmark.identifier)")
        BatteryMonitor.shared.startMonitoring()
        
        shortDelay { [weak self] in
            // We want to make sure the device is fully charged
            // and disconnected before each test
            self?.powerControl.connect {
                self?.powerControl.fullyRecharge {
                    assert(BatteryMonitor.shared.state == .full)
                    assert(BatteryMonitor.shared.level == 1.0)
                    onComplete()
                }
            }
        }
    }
    
    
    func execute(onCompletion:@escaping BenchmarkExecutorBlock) {
        setup { [weak self] in
            self!.powerControl.disconnect {
                assert(BatteryMonitor.shared.state == .unplugged)
                assert(BatteryMonitor.shared.level == 1.0)
                
                DispatchQueue.global().async {
                    let start = DispatchTime.now()
                    self!.benchmark.execute()
                    self!.teardown(start) {
                        onCompletion()
                    }
                };
            }
        }
        
    }
    
    private func teardown(_ start:DispatchTime, onCompletion:@escaping BenchmarkExecutorBlock) {
        let battery = 1.0 - BatteryMonitor.shared.level
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        self.benchmark.validate()
        
        
        BenchmarkReport.shared.add(result: BenchmarkResult(
            category: self.benchmark.category,
            identifier: self.benchmark.identifier,
            battery:battery,
            duration: timeInterval
        ))
        
        self.powerControl.connect { [weak self] in
            BatteryMonitor.shared.stopMonitoring()
            self!.shortDelay {
                onCompletion()
            }
        }
    }
}
