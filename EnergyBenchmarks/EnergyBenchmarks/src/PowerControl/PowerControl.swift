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
    
    func reduceBrightness() {
        DispatchQueue.main.async {
            UIScreen.main.brightness = 0
        }
    }
    
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
            completeWaitForState(onComplete)
        } else {
//            eblog(level:.Info, "current state: \(BatteryMonitor.shared.state.string) \(BatteryMonitor.shared.level)")
            BatteryMonitor.shared.report = { [weak self] level, state in
                guard let self = self else {return}
                if self.satisfiesCondition(states, expectedLevel) {
                    self.completeWaitForState(onComplete)
                    BatteryMonitor.shared.report = nil
                }
            };
        }
    }
    
    private func satisfiesCondition(_ states:[UIDevice.BatteryState], _ expectedLevel:Float?) -> Bool {
        let state = BatteryMonitor.shared.state
        let level = BatteryMonitor.shared.level
        return states.contains(state) && (expectedLevel == nil || expectedLevel == level)
    }
    
    private func completeWaitForState(_ onComplete:@escaping PowerControlOnComplete) {
        eblog?("fulfill current state: \(BatteryMonitor.shared.state.string) \(BatteryMonitor.shared.level)")
        onComplete()
    }
    
    func executeWithTimeout(execute:@escaping (@escaping ()->())->(), onComplete:@escaping ()->(), onRetry:@escaping ()->()) {
        DispatchQueue.main.async { [weak self] in
//            eblog(level:.Info, "executeWithTimeout start")
            var timer:Timer?
            timer = Timer.scheduledTimer(withTimeInterval: self!.TIMEOUT, repeats: false) { _ in
//                eblog(level:.Info, "executeWithTimeout retry")
                timer = nil
                onRetry()
            }
            
            
            DispatchQueue.global().async {
                execute {
                    guard let timer = timer else {return}
//                    eblog(level:.Info, "executeWithTimeout finish")
                    timer.invalidate()
                    onComplete()
                }

            }
        }
    }
    
    
    func connect(onComplete:@escaping PowerControlOnComplete) {
        
        executeWithTimeout { [weak self] complete in
            eblog?("--- waiting for charger connection ---")
            self!.webHook.startCharging()
            self!.waitForState(states: [.charging,.full]) {
                complete()
            }
        } onComplete: {
            onComplete()
        } onRetry: { [weak self] in
            self!.connect(onComplete: onComplete)
        }
    }
    
    func fullyRecharge(onComplete:@escaping PowerControlOnComplete) {
        connect() { [weak self] in
            eblog?("--- waiting for full battery ---")
            self?.waitForState(states: [.full], 1.0) {
                onComplete()
            }
        }
    }
    
    func disconnect(onComplete:@escaping PowerControlOnComplete) {
        executeWithTimeout { [weak self] complete in
            eblog?("--- waiting for charger disconnection ---")
            self?.webHook.stopCharging()
            self?.waitForState(states: [.unplugged]) {
                complete()
            }
        } onComplete: {
            onComplete()
        } onRetry: { [weak self] in
            self?.disconnect(onComplete: onComplete)
        }
    }
}
