//
//  ConcurrencySequential.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 10/07/21.
//

import Foundation

class ConcurrencySequential: ConcurrencyBenchmark {
    
    var identifier: String { "Sequential \(intIdFormat(CONCURRENCY_COUNT_GOAL))" }
    var count = 0
    
    func execute() {
        for _ in 1...self.CONCURRENCY_COUNT_GOAL {
            count += 1
        }
    }
    
    func validate() {
//        assert(count == self.CONCURRENCY_COUNT_GOAL)
    }
    
}
