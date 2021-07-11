//
//  ConcurrencyBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 10/07/21.
//

import Foundation

protocol ConcurrencyBenchmark: Benchmark {}

extension ConcurrencyBenchmark {
    var CONCURRENCY_COUNT_GOAL:Int { 2_000_000_000 }
//    var CONCURRENCY_COUNT_GOAL:Int { 1_000_000 }
    var category: String { "Concurrency" }
}
