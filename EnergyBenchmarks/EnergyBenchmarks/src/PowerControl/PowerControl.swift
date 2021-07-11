//
//  PowerControl.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 10/07/21.
//

import UIKit

typealias PowerControlOnComplete = () -> ()

class PowerControl {
    
    let TIMEOUT:TimeInterval = 10
    
    let webHook = SmartSwitchWebhook()
    
    func handleUnknownState(onComplete:@escaping PowerControlOnComplete) {
        if BatteryMonitor.shared.state == .unknown {
            disconnect() { [weak self] in
                self?.connect() {
                    onComplete()
                }
            }
        } else {
            onComplete()
        }
    }
    
    func waitForState(states:[UIDevice.BatteryState], _ expectedLevel:Float? = nil, onComplete:@escaping PowerControlOnComplete) {
        if satisfiesCondition(states, expectedLevel) {
            let state = BatteryMonitor.shared.state
            let level = BatteryMonitor.shared.level
            log("fulfill current state: \(state) \(level)")
            onComplete()
        } else {
            log("current state: \(BatteryMonitor.shared.state.string) \(UIDevice.current.batteryState.string)")
            BatteryMonitor.shared.report = { [weak self] level, state in
                guard let self = self else {return}
                if self.satisfiesCondition(states, expectedLevel) {
                    log("fulfill current state: \(state) \(level)")
                    onComplete()
                }
            };
        }
    }
    
    func satisfiesCondition(_ states:[UIDevice.BatteryState], _ expectedLevel:Float?) -> Bool {
        let state = BatteryMonitor.shared.state
        let level = BatteryMonitor.shared.level
        return states.contains(state) && (expectedLevel == nil || expectedLevel == level)
    }
    
    func executeWithTimeout(execute:@escaping (@escaping ()->())->(), onComplete:@escaping ()->(), onRetry:@escaping ()->()) {
        var completed = false
        var dismissed = false
        
        execute {
            if !dismissed {
                completed = true
                onComplete()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TIMEOUT) {
            if !completed {
                dismissed = true
                onRetry()
            }
        }
        
    }
    
    
    func connect(onComplete:@escaping PowerControlOnComplete) {
        
        executeWithTimeout { [weak self] done in
            self?.handleUnknownState() {
                log("waiting for charger connection")
                self?.webHook.startCharging()
                self?.waitForState(states: [.charging,.full]) {
                    done()
                }
            }
        } onComplete: {
            onComplete()
        } onRetry: { [weak self] in
            self?.connect(onComplete: onComplete)
        }
    }
    
    func fullyRecharge(onComplete:@escaping PowerControlOnComplete) {
        connect() { [weak self] in
            log("waiting for full battery")
            self?.waitForState(states: [.full], 1.0) {
                onComplete()
            }
        }
    }
    
    func disconnect(onComplete:@escaping PowerControlOnComplete) {
        executeWithTimeout { [weak self] done in
            log("waiting for charger disconnection")
            self?.webHook.stopCharging()
            self?.waitForState(states: [.unplugged]) {
                done()
            }
        } onComplete: {
            onComplete()
        } onRetry: { [weak self] in
            self?.disconnect(onComplete: onComplete)
        }
    }
}
