//
//  BenchmarkReport.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 11/07/21.
//

import Foundation

class BenchmarkReport {
    
    private static let instance = BenchmarkReport()
    
    var results = [BenchmarkResult]()
    var failure = false
    
    static func add(result:BenchmarkResult) {
        instance.results.append(result)
        print(result:result)
        ReportService.report(result: result)
    }
    
    static func reset() {
        instance.results.removeAll()
        instance.failure = false
    }
    
    static func report() {
        if !instance.failure {
            eblog?("TEST REPORT:")
            for result in instance.results {
                print(result:result)
            }
        }
        reset()
    }
    
    static func print(result:BenchmarkResult) {
        eblog?("### REPORT Category: \(result.category) - Id: \(result.identifier) - Battery: \(result.battery) - duration: \(result.duration) - os: \(result.os) - model: \(result.model) - name: \(result.name) - cores: \(result.cores) - osVersion: \(result.osVersion) - info: \(result.info)")
    }
    
}
