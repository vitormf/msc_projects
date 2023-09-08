//
//  SleepBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 15/07/21.
//

import Foundation

protocol SleepBenchmark: BenchmarkSynchronous {
    var sleepTime:TimeInterval { get }
}

extension SleepBenchmark {
    var category: String { "Sleep" }
    var info: String { "" }
    
    func execute() {
        Thread.sleep(forTimeInterval: sleepTime)
    }
}

class SleepBenchmark10min: SleepBenchmark {
    var sleepTime:TimeInterval = 10 * 60
    var identifier: String { "Sleep 10 min" }
}

class SleepBenchmark30min: SleepBenchmark {
    var sleepTime:TimeInterval = 30 * 60
    var identifier: String { "Sleep 30 min" }
}

class SleepBenchmark45min: SleepBenchmark {
    var sleepTime:TimeInterval = 45 * 60
    var identifier: String { "Sleep 45 min" }
}

class SleepBenchmark1hour: SleepBenchmark {
    var sleepTime:TimeInterval = 60 * 60
    var identifier: String { "Sleep 1 hour" }
}

class SleepBenchmark1hour30min: SleepBenchmark {
    var sleepTime:TimeInterval = 1.5 * 60 * 60
    var identifier: String { "Sleep 1 hour 30min" }
}

class SleepBenchmark2hour: SleepBenchmark {
    var sleepTime:TimeInterval = 2 * 60 * 60
    var identifier: String { "Sleep 2 hours" }
}

class SleepBenchmark3hour: SleepBenchmark {
    var sleepTime:TimeInterval = 3 * 60 * 60
    var identifier: String { "Sleep 3 hours" }
}

class SleepBenchmark4hour: SleepBenchmark {
    var sleepTime:TimeInterval = 4 * 60 * 60
    var identifier: String { "Sleep 4 hours" }
}

let allSleepBenchmarks:[Benchmark] = [
    SleepBenchmark10min(),
    SleepBenchmark30min(),
    SleepBenchmark45min(),
    SleepBenchmark1hour(),
    SleepBenchmark1hour30min(),
    SleepBenchmark2hour(),
    SleepBenchmark3hour(),
    SleepBenchmark4hour(),
    SleepTrackingBenchmark(),
]

