//
//  ArrayRemoveFirst.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 15/07/21.
//

import Foundation

protocol ArrayRemoveFirstBenchmark: ArrayBenchmark{}
extension ArrayRemoveFirstBenchmark {
    var GOAL: UInt64 { MAX_ARRAY_SIZE * 100 }
    var MAX_ARRAY_SIZE: UInt64 { 10_000 }
}

class SwiftArrayRemoveFirst: ArrayRemoveFirstBenchmark {
    
    var subidentifier: String { "Array.removeFirst()" }
    
    func execute() {
        var array = [UInt64](repeating: 0, count: Int(self.MAX_ARRAY_SIZE))
        for i in 0...self.GOAL {
            array.removeFirst()
            if i % self.MAX_ARRAY_SIZE == 0 {
                array = [UInt64](repeating: 0, count: Int(self.MAX_ARRAY_SIZE))
            }
        }
    }
    
}

class NSMutableArrayRemoveObjectAtFirst: ArrayRemoveFirstBenchmark {
    
    var subidentifier: String { "NSMutableArray.removeFirstObject()" }
    
    func execute() {
        var array = createArray()
        for i in 0...self.GOAL {
            array.removeObject(at: 0)
            if i % self.MAX_ARRAY_SIZE == 0 {
                array = createArray()
            }
        }
    }
    
    func createArray() -> NSMutableArray {
        let array = NSMutableArray(capacity: Int(self.MAX_ARRAY_SIZE))
        for i in 0...self.MAX_ARRAY_SIZE {
            array.add(i)
        }
        return array
    }
    
}
