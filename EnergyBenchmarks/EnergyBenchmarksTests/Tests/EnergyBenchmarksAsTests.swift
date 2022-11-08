//
//  ConcurrencyBenchmarks.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 22/06/21.
//

import XCTest
@testable import EnergyBenchmarks

class EnergyBenchmarksAsTests: XCTestCase {
    
    let timeout:TimeInterval = 172800 // overestimating timeout to 2 days
    
    func execute(benchmarks: [Benchmark]) {
        let suite = BenchmarkExecutionSuite(benchmarks: benchmarks)
        
        let expectation = XCTestExpectation(description: "benchmark completed")
        suite.execute { completed, _, _, result in
            if completed {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    
    func testConcurrency() {
        execute(benchmarks: allConcurrencyBenchmarks)
    }
    
    func testArrays() {
        execute(benchmarks: allArrayBenchmarks)
    }
    
}
