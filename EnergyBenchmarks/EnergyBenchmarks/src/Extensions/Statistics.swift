//
//  Statistics.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 14/07/21.
//

import Foundation

extension Array where Element: FloatingPoint {

    func sum() -> Element {
        return self.reduce(0, +)
    }

    func avg() -> Element {
        return self.sum() / Element(self.count)
    }

    func std() -> Element {
        let mean = self.avg()
        let v = self.reduce(0, { $0 + ($1-mean)*($1-mean) })
        return sqrt(v / (Element(self.count) - 1))
    }

    
    func median() -> Element {
        let sorted = self.sorted()
        let length = self.count
        
        if (length % 2 == 0) {
            return (sorted[length / 2 - 1] + sorted[length / 2]) / Element(2)
        }
        
        return sorted[length / 2]
    }
    
}
