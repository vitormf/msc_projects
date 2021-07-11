//
//  ConcurrencyOperationQueue.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 10/07/21.
//

import Foundation

class ConcurrencyOperationQueue: ConcurrencyBenchmark {
    var identifier: String { "OperationQueue(\(concurrency))" }
    
    var concurrency:Int
    let queue = OperationQueue()
    var testGoal:Int {
        self.CONCURRENCY_COUNT_GOAL/concurrency
    }
    
    init(concurrency:Int) {
        self.concurrency = concurrency
        queue.maxConcurrentOperationCount = concurrency
    }
    
    func execute() {
        let testGoal =  self.testGoal;
        for _ in 1...concurrency {
            queue.addOperation {
                var count = 0
                for _ in 1...testGoal {
                    count += 1
                }
                assert(testGoal == count)
            }
        }
        queue.waitUntilAllOperationsAreFinished()
    }
}

class ConcurrencyOperationQueue2: ConcurrencyOperationQueue {
    init() {super.init(concurrency: 2) }
}

class ConcurrencyOperationQueue4: ConcurrencyOperationQueue {
    init() {super.init(concurrency: 4) }
}

class ConcurrencyOperationQueue8: ConcurrencyOperationQueue {
    init() {super.init(concurrency: 8) }
}

class ConcurrencyOperationQueue16: ConcurrencyOperationQueue {
    init() {super.init(concurrency: 16) }
}

