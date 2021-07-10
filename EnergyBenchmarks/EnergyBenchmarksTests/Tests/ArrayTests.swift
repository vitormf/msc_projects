//
//  ArrayTests.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 21/06/21.
//

import XCTest
@testable import EnergyBenchmarks

class ArrayTests: EnergyTest {
    
    override class func setUp() {
        EnergyMonitor.shared.startMonitoring()
    }
    
    
    let ADD_GOAL = 1_000_000_000
    
    func printProgress(_ i:Int) {
        print("\(Double(i)/Double(self.ADD_GOAL)*100)%")
    }
    
    func testAddSwiftArray() {
        executeTest("ArrayTests:Array.append()") {
            var array = [Int]()
            for i in 0...self.ADD_GOAL {
                array.append(i)
                if i % 1_000_000 == 0 {
                    array = [Int]()
                    self.printProgress(i)
                }
            }
        }
    }
    
    func testAddNSMutableArray() {
        executeTest("ArrayTests:NSMutableArray.add()") {
            var array = NSMutableArray()
            for i in 0...self.ADD_GOAL {
                array.add(i)
                if i % 1_000_000 == 0 {
                    array = NSMutableArray()
                    self.printProgress(i)
                }
            }
        }
    }
    
    
}
