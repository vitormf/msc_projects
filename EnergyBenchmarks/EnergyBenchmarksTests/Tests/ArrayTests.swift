//
//  ArrayTests.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 21/06/21.
//

import XCTest
@testable import EnergyBenchmarks

class ArrayTests: BatteryBenchmarkTest {
    
    func testArrayAppend() {
        execute(benchmark: SwiftArrayAppend())
    }
    
    func testOperationQueue2() {
        execute(benchmark: NSMutableArrayAdd())
    }
    
}
