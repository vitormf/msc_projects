//
//  ConcurrencyBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 10/07/21.
//

import Foundation

protocol ConcurrencyBenchmark: BenchmarkSynchronous {}

extension ConcurrencyBenchmark {
    var CONCURRENCY_COUNT_GOAL:UInt64 { 10_000_000_000 }
//    var CONCURRENCY_COUNT_GOAL:UInt64 { 1_000_000 }
    var category: String { "Concurrency" }
    var info: String { "Executed with concurrency goal \(formatInt(CONCURRENCY_COUNT_GOAL))" }
}

let allConcurrencyBenchmarks:[Benchmark] = [
    ConcurrencySequential(),
    ConcurrencyOperationQueue2(),
    ConcurrencyOperationQueue4(),
    ConcurrencyOperationQueue8(),
    ConcurrencyOperationQueue16(),
]
