//
//  BenchmarkReport.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 11/07/21.
//

import Foundation

class BenchmarkReport {
    
    static let shared = BenchmarkReport()
    
    var results = [BenchmarkResult]()
    var failure = false
    
    func add(result:BenchmarkResult) {
        results.append(result)
    }
    
    func reset() {
        results.removeAll()
        failure = false
    }
    
    func report() {
        if !failure {
            for result in results {
                print("### REPORT Category: \(result.category) - Id: \(result.identifier) - Battery: \(result.battery) - duration: \(result.duration) - system: \(result.system) - model: \(result.model) - name: \(result.name) - cores: \(result.cores) - osVersion: \(result.osVersion)")
            }
        }
        reset()
    }
    
}
