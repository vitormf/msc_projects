//
//  ConcurrencyBenchmarks.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 22/06/21.
//

import XCTest
@testable import EnergyBenchmarks

class ConcurrencyBenchmarks: BatteryBenchmarkTest {
    
    func testSequential() {
        execute(benchmark: ConcurrencySequential())
    }
    
    func testOperationQueue2() {
        execute(benchmark: ConcurrencyOperationQueue2())
    }
    
    func testOperationQueue4() {
        execute(benchmark: ConcurrencyOperationQueue4())
    }
    
    func testOperationQueue8() {
        execute(benchmark: ConcurrencyOperationQueue8())
    }
    
    func testOperationQueue16() {
        execute(benchmark: ConcurrencyOperationQueue16())
    }
    
}
