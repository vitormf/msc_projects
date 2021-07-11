//
//  ArrayBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 11/07/21.
//

import Foundation

protocol ArrayBenchmark: Benchmark {}

extension ArrayBenchmark {
    var ADD_GOAL: Int { 1_000_000_000 }
    var MODULE: Int { 1_000_000 }
    var category: String { "Arrays" }
}
