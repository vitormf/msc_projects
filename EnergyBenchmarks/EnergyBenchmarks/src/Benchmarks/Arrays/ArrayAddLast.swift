//
//  ArrayAddLast.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 15/07/21.
//

import Foundation

protocol ArrayAddLastBenchmark: ArrayBenchmark {}
extension ArrayAddLastBenchmark {
    var GOAL: UInt64 { MAX_ARRAY_SIZE * 400 }
    var MAX_ARRAY_SIZE: UInt64 { 10_000_000 }
}


class SwiftArrayAppend: ArrayAddLastBenchmark {
    
    var subidentifier: String { "Array.append(...)" }
    
    func execute() {
        var array = [UInt64]()
        for i in 0...self.GOAL {
            array.append(i)
            if i % self.MAX_ARRAY_SIZE == 0 {
                printProgress(i)
                array = [UInt64]()
            }
        }
    }
    
}


class NSMutableArrayAdd: ArrayAddLastBenchmark {
    
    var subidentifier: String { "NSMutableArray.add(...)" }
    
    func execute() {
        var array = NSMutableArray()
        for i in 0...self.GOAL {
            array.add(i)
            if i % self.MAX_ARRAY_SIZE == 0 {
                printProgress(i)
                array = NSMutableArray()
            }
        }
    }
    
}
