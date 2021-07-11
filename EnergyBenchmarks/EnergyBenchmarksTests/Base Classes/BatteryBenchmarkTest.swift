//
//  BatteryBenchmarkTest.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 19/06/21.
//

import XCTest
@testable import EnergyBenchmarks

class BatteryBenchmarkTest: XCTestCase {
    
    func execute(benchmark:Benchmark) {
        let expectation = XCTestExpectation(description: "prepare test")
        let execution = BenchmarkExecution(benchmark)
        execution.execute {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10800)
    }
    
    static override func tearDown() {
        BenchmarkReport.shared.report()
    }
    
    
    override func record(_ issue: XCTIssue) {
        BenchmarkReport.shared.failure = true
    }
}

