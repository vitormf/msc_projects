//
//  Throughput.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 18/01/23.
//

import Foundation

let allThroughputBenchmarks:[Benchmark] = [
    ThroughputBenchmark()
]



class ThroughputBenchmark: BenchmarkSynchronous {
    var category:String = "Throughput"
    var identifier:String = "Throughput"
    var info:String = "Throughput"

    var executionsPerBattery = [Float:UInt64]()

    func execute() {
        while(BatteryMonitor.shared.level > 1) {
            executeCycle()
            let battery = BatteryMonitor.shared.level
            let currentValue = executionsPerBattery[battery] ?? 0
            print(currentValue)
            executionsPerBattery[battery] = currentValue + 1
        }

    }

    func executeCycle() {
        var i = 0
        while(i < 1_000_000) {
            i += 1
        }
    }

    func validate() {}
}
