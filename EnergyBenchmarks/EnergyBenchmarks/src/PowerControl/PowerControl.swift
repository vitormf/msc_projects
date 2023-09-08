//
//  PowerControl.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 10/07/21.
//

import UIKit

typealias PowerControlOnComplete = () -> ()

class PowerControl {

    static var ignoreCharger = false

    static let shared = PowerControl()

    static let START_BATTERY_LEVEL:Float = 0.80;
    static let START_BATTERY_LEVEL_MARGIN:Float = 0.81;

    static let TIMEOUT:TimeInterval = 10
    
    let webHook = SmartSwitchWebhook()

    func reduceBrightness() {
        DispatchQueue.main.async {
            UIScreen.main.brightness = 0
        }
    }

    func increaseBrightness() {
        DispatchQueue.main.async {
            UIScreen.main.brightness = 1
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
            BatteryMonitor.shared.addListener { level, state, id in
                if self.satisfiesCondition(states, expectedLevel) {
                    self.completeWaitForState(onComplete)
                    BatteryMonitor.shared.removeListener(listenerId: id)
                }
            }
        }
    }
    
    private func satisfiesCondition(_ states:[UIDevice.BatteryState], _ expectedLevel:Float? = nil) -> Bool {
        if PowerControl.ignoreCharger {
            return true
        }
        let state = BatteryMonitor.shared.state
        let level = BatteryMonitor.shared.level
        let satisfies = states.contains(state) && (expectedLevel == nil || expectedLevel == level)
        eblog?("satisfiesCondition => \(satisfies)")
        return satisfies
    }
    
    private func completeWaitForState(_ onComplete:@escaping PowerControlOnComplete) {
        eblog?("fulfill current state: \(BatteryMonitor.shared.state.string) \(BatteryMonitor.shared.level)")
        onComplete()
    }
    
    func executeWithTimeout(execute:@escaping (@escaping ()->())->(), onComplete:@escaping ()->(), onRetry:@escaping ()->()) {
        DispatchQueue.main.async { 
//            eblog(level:.Info, "executeWithTimeout start")
            var timer:Timer?
            timer = Timer.scheduledTimer(withTimeInterval: PowerControl.TIMEOUT, repeats: false) { _ in
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
            if (self!.satisfiesCondition([.charging, .full])) {
                complete()
            } else {
                eblog?("--- waiting for charger connection ---")
                self!.webHook.startCharging()
                self!.waitForState(states: [.charging,.full]) {
                    complete()
                }
            }

        } onComplete: {
            onComplete()
        } onRetry: { [weak self] in
            self!.connect(onComplete: onComplete)
        }
    }

    func discharge(onComplete:@escaping PowerControlOnComplete) {
        disconnect { [weak self] in
            eblog?("--- Discharging until \(PowerControl.START_BATTERY_LEVEL) battery ---")
//            ebspeak("discharging")
            var discharging: Bool = true
            self!.increaseBrightness()
            self!.waitForState(states: [.unplugged], PowerControl.START_BATTERY_LEVEL) {
                 self!.reduceBrightness()
                discharging = false
                onComplete()
            }

            DispatchQueue.global(qos:.userInitiated).async {
                eblog?("new discharge thread")
                var count:UInt64 = 0
                let image = UIImage(named: "tree.jpg")!
                let benchmark = MobileNetV2TFLite(1)
                while (discharging){
                    count = (count+1)%1_000
                    if (count == 0) {
                        DispatchQueue.main.async {
                            eblog?("discharging")
                        }
                    }
                    let _ = benchmark.classify(0, image)
                }
                eblog?("end discharge thread")
            }

//            for _ in 0...ProcessInfo.processInfo.activeProcessorCount {
//                DispatchQueue.global(qos:.background).async {
//                    eblog?("new discharge thread")
//                    var count:UInt64 = 0
//                    while(discharging) {
//                        count = (count+1)%1_000_000_000
//                        if (count == 0) {
//                            DispatchQueue.main.async {
//                                eblog?("discharging")
//                            }
//                        }
//                    }
//                    eblog?("end discharge thread")
//                }
//
//            }

        }
    }
    
    func recharge(onComplete:@escaping PowerControlOnComplete) {
        connect() { [weak self] in
            eblog?("--- Recharging until \(PowerControl.START_BATTERY_LEVEL_MARGIN) battery ---")
//            ebspeak("recharging")
            self?.waitForState(states: [.charging], PowerControl.START_BATTERY_LEVEL_MARGIN) {
                onComplete()
            }
        }
    }
    
    func disconnect(onComplete:@escaping PowerControlOnComplete) {
        executeWithTimeout { [weak self] complete in
            if (self!.satisfiesCondition([.unplugged])) {
                complete()
            } else {
                eblog?("--- waiting for charger disconnection ---")
                self!.webHook.stopCharging()
                self!.waitForState(states: [.unplugged]) {
                    complete()
                }
            }

        } onComplete: {
            onComplete()
        } onRetry: {
            self.disconnect(onComplete: onComplete)
        }
    }
}
