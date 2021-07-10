//
//  ThreadsTest.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 22/06/21.
//

import XCTest
@testable import EnergyBenchmarks

class ThreadsTest: EnergyTest {
    
    override class func setUp() {
        EnergyMonitor.shared.startMonitoring()
    }
    
//    let TEST_GOAL = 10_000_000_000
    let TEST_GOAL = 10_000_000
    var count = 0
    
    func actionToBeTested() {
        count += 1
    }
    
    override func setUp() {
        super.setUp()
        count = 0
    }
    
    func testSequential() {
        executeTest("ThreadsTest:sequential") {
            for _ in 1...self.TEST_GOAL {
                self.actionToBeTested()
            }
        }
        XCTAssertEqual(TEST_GOAL, count)
    }
    
    
    func operationQueueTest(concurrency:Int) {
        executeTest("ThreadsTest:operationQueue(\(concurrency))") {
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = concurrency
            
            for _ in 1...concurrency {
                queue.addOperation {
                    for _ in 1...self.TEST_GOAL/concurrency {
                        self.actionToBeTested()
                    }
                }
            }
            
            queue.waitUntilAllOperationsAreFinished()
        }
//        XCTAssertEqual(TEST_GOAL, count)
    }
    
    func testOperationQueue2() {
        operationQueueTest(concurrency: 2)
    }
    
    func testOperationQueue4() {
        operationQueueTest(concurrency: 4)
    }
    
    func testOperationQueue8() {
        operationQueueTest(concurrency: 8)
    }
    
    func testOperationQueue16() {
        operationQueueTest(concurrency: 16)
    }
    
    
    
}
