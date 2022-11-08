//
//  SleepTrackingBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 16/07/21.
//

import Foundation

class SleepTrackingBenchmark: Benchmark {
    var category: String = "SleepTracking"
    
    var identifier: String = "Total"
    
    var info: String = ""
    
    var startTime = NSDate().timeIntervalSince1970
    
    var tracking = [Float:TimeInterval]()
    
    func execute() {
        startTime = NSDate().timeIntervalSince1970
        track(battery: BatteryMonitor.shared.level)
        let semaphore = DispatchSemaphore(value: 0)
        BatteryMonitor.shared.report = { level, state in
            
            self.track(battery: level)
            if level == 0.01 {
                semaphore.signal()
            }
        }
        semaphore.wait()
    }
    
    func track(battery:Float) {
        DispatchQueue.global().async {
            self.tracking[battery] = NSDate().timeIntervalSince1970 - self.startTime
            if battery == 0.01 {
                self.sendBenchmarks()
            }
        }
    }
    
    func sendBenchmarks() {
        for t in tracking {
            sendBenchmarks(battery: t.key, time: t.value)
        }
    }
    
    func sendBenchmarks(battery:Float, time:TimeInterval) {
        let batteryConsumption = Int(round(100 - battery*100))
        let result = BenchmarkResult(
            category: self.category,
            identifier: "\(batteryConsumption)",
            info: self.info,
            battery: UInt(batteryConsumption),
            duration: time
        )
        BenchmarkReport.add(result: result)
    }
    
}
