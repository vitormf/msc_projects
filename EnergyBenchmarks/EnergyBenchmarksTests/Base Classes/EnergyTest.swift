//
//  EnergyTest.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 19/06/21.
//

import XCTest
@testable import EnergyBenchmarks

typealias EnergyTestBlock = ()->Void

class EnergyTest: XCTestCase {
    
    let webHook = SmartSwitchWebhook()
    
    func handleUnknownState() {
        if EnergyMonitor.shared.state == .unknown {
            waitForChargerDisconnect()
            waitForChargerConnection()
        }
    }
    
    func waitForState(states:[UIDevice.BatteryState], _ expectedLevel:Float? = nil, timeout:TimeInterval) {
        if !states.contains(EnergyMonitor.shared.state) {
            etdebug("current state: \(EnergyMonitor.shared.state.string) \(UIDevice.current.batteryState.string)")
            let statesString = states.map { state in
                state.string
            }.joined(separator: ",")
            let expectedState = XCTestExpectation(description: "expect state: \(statesString)")
            EnergyMonitor.shared.report = { level, state in
                if (states.contains(state)) {
                    if (expectedLevel != nil) {
                        if (level == expectedLevel) {
                            etdebug("fulfill current state: \(EnergyMonitor.shared.state.string) \(level)")
                            expectedState.fulfill()
                        }
                    } else {
                        etdebug("fulfill current state: \(EnergyMonitor.shared.state.string)")
                        expectedState.fulfill()
                    }
                    
                }
            };
            
            wait(for: [expectedState], timeout: timeout)
        }
    }
    
    
    func waitForChargerConnection() {
        handleUnknownState()
        etdebug("waiting for charger connection")
        webHook.startCharging()
        waitForState(states: [.charging,.full], timeout: 60)
    }
    
    func waitForBatteryFull() {
        waitForChargerConnection()
        etdebug("waiting for full battery")
        // assume a device will take at most 2 hours to fully recharge
        waitForState(states: [.full], 1.0, timeout: 7200)
    }
    
    func waitForChargerDisconnect() {
        etdebug("waiting for charger disconnection")
        webHook.stopCharging()
        waitForState(states: [.unplugged], timeout: 60)
    }
    
    
    override func setUp() {
        continueAfterFailure = false
        // We want to make sure the device is fully charged
        // and disconnected before each test
        waitForBatteryFull();
        waitForChargerDisconnect()
    }

    override func tearDown() {
        // at the end of the test replug the charger
        waitForChargerConnection()
//        EnergyMonitor.shared.stopMonitoring()
    }

    func prepareTest(block:@escaping EnergyTestBlock) {
        waitForBatteryFull()
        let expectation = XCTestExpectation(description: "preparing test")
        DispatchQueue.global().async {
            block()
            expectation.fulfill()
        };
        wait(for: [expectation], timeout: 36000)
        waitForChargerDisconnect()
    }
    
    func executeTest(_ testId:String, block:@escaping EnergyTestBlock) {
        waitForChargerDisconnect()
        XCTAssertEqual(EnergyMonitor.shared.state, .unplugged)
        XCTAssertEqual(EnergyMonitor.shared.level, 1.0)
        
        let expectation = XCTestExpectation(description: "executing test")
        let start = DispatchTime.now()
        DispatchQueue.global().async {
            block()
            expectation.fulfill()
        };
        wait(for: [expectation], timeout: 36000)
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        TestReport.publishReport(identifier: testId, battery: EnergyMonitor.shared.level, duration: timeInterval)
    }
    
}
