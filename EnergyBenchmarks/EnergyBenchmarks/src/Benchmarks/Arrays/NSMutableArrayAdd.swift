//
//  NSMutableArrayAdd.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 11/07/21.
//

import Foundation

class NSMutableArrayAdd: ArrayBenchmark {
    
    var identifier: String { "NSMutableArray.add" }
    
    func execute() {
        var array = NSMutableArray()
        for i in 0...self.ADD_GOAL {
            array.add(i)
            if i % self.MODULE == 0 {
                array = NSMutableArray()
            }
        }
    }
    
}
