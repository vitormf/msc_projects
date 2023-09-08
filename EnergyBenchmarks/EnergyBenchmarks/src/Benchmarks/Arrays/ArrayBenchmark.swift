//
//  ArrayBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 11/07/21.
//

import Foundation

let allArrayBenchmarks:[Benchmark] = [
    NSMutableArrayAdd(),
    NSMutableArrayInsertAtFirst(),
    NSMutableArrayRemoveLastObject(),
    NSMutableArrayRemoveObjectAtFirst(),
    SwiftArrayAppend(),
    SwiftArrayInsertAtFirst(),
    SwiftArrayRemoveLast(),
    SwiftArrayRemoveFirst()
]

protocol ArrayBenchmark: BenchmarkSynchronous {
    var GOAL: UInt64 { get }
    var MAX_ARRAY_SIZE: UInt64 { get }
    var subidentifier: String { get }
}

extension ArrayBenchmark {
    var category: String { "Arrays" }
    var info: String { "Goal \(formatInt(GOAL)) and max array size \(formatInt(MAX_ARRAY_SIZE))" }
    var idExtra: String { "\(goalString(GOAL/MAX_ARRAY_SIZE)) x \(goalString(MAX_ARRAY_SIZE))" }
    var identifier: String { "\(subidentifier) \(idExtra)" }
    
    func printProgress(_ i:UInt64) {
        if logLevel.rawValue <= LogLevel.Info.rawValue {
            let progress = (i*100)/self.GOAL
            eblogInfo?("\(progress)%")
        }
    }
    
    private func goalString(_ value:UInt64) -> String{
        return intIdFormat(value)
    }
}

protocol ArrayNewBenchmark: ArrayBenchmark {}
extension ArrayNewBenchmark {
    var GOAL: UInt64 { 1_000_000_000 }
//    var GOAL: UInt64 { 1_000 }
    var MAX_ARRAY_SIZE: UInt64 { 10_000_000 }
}

