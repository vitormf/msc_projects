//
//  SwiftArrayAppend.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 11/07/21.
//

import Foundation

class SwiftArrayAppend: ArrayBenchmark {
    
    var identifier: String { "Array.append" }
    
    func execute() {
        var array = [Int]()
        for i in 0...self.ADD_GOAL {
            array.append(i)
            if i % self.MODULE == 0 {
                array = [Int]()
            }
        }
    }
    
}
