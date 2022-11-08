//
//  ArrayAddFirst.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 15/07/21.
//

import Foundation


protocol ArrayAddFirstBenchmark: ArrayBenchmark {}
extension ArrayAddFirstBenchmark {
    var GOAL: UInt64 { MAX_ARRAY_SIZE * 100 }
    var MAX_ARRAY_SIZE: UInt64 { 300_000 }
}

class SwiftArrayInsertAtFirst: ArrayAddFirstBenchmark {
    
    var subidentifier: String { "Array.insert(..., at:0)" }
    
    func execute() {
        var array = [UInt64]()
        for i in 0...self.GOAL {
            array.insert(i, at: 0)
            if i % self.MAX_ARRAY_SIZE == 0 {
                printProgress(i)
                array = [UInt64]()
            }
        }
    }
    
}

class NSMutableArrayInsertAtFirst: ArrayAddFirstBenchmark {
    
    var subidentifier: String { "NSMutableArray.add(..., at:0)" }
    
    func execute() {
        var array = NSMutableArray()
        for i in 0...self.GOAL {
            array.insert(i, at: 0)
            if i % self.MAX_ARRAY_SIZE == 0 {
                printProgress(i)
                array = NSMutableArray()
            }
        }
    }
    
}
