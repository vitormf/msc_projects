//
//  ArrayRemoveLast.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 15/07/21.
//

import Foundation

protocol ArrayRemoveLastBenchmark: ArrayBenchmark{}
extension ArrayRemoveLastBenchmark {
    var GOAL: UInt64 { MAX_ARRAY_SIZE * 100 }
    var MAX_ARRAY_SIZE: UInt64 { 10_000_000 }
}

class SwiftArrayRemoveLast: ArrayRemoveLastBenchmark {
    
    var subidentifier: String { "Array.removeLast()" }
    
    func execute() {
        var array = [UInt64](repeating: 0, count: Int(self.MAX_ARRAY_SIZE))
        for i in 0...self.GOAL {
            array.removeLast()
            if i % self.MAX_ARRAY_SIZE == 0 {
                array = [UInt64](repeating: 0, count: Int(self.MAX_ARRAY_SIZE))
            }
        }
    }
    
}


class NSMutableArrayRemoveLastObject: ArrayRemoveLastBenchmark {
    
    var subidentifier: String { "NSMutableArray.removeLastObject()" }
    
    func execute() {
        var array = createArray()
        for i in 0...self.GOAL {
            array.removeLastObject()
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
