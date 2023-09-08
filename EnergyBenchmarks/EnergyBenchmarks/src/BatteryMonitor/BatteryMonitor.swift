//
//  BatteryMonitor.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 19/06/21.
//

import UIKit

typealias BatteryMonitorReport = (Float, UIDevice.BatteryState, Int) -> Void

class BatteryMonitor {
    
    static let shared = BatteryMonitor()
    
    var level:Float {
        UIDevice.current.batteryLevel
    };
    
    var state:UIDevice.BatteryState {
        UIDevice.current.batteryState
    }

    private static var listenerId = 0
    private var listeners = [Int:BatteryMonitorReport]()

    @discardableResult
    func addListener(listener:@escaping BatteryMonitorReport) -> Int {
        let id = BatteryMonitor.listenerId
        BatteryMonitor.listenerId += 1
        listeners[id] = listener
        return id
    }

    func removeListener(listenerId:Int) {
        listeners[listenerId] = nil
    }
    
    @objc
    func batteryLevelDidChange(notification: NSNotification) {
        logBattery()
        for k in listeners.keys {
            listeners[k]?(level, state, k)
        }
    }

    @objc
    func batteryStateDidChange(notification: NSNotification) {
        logBattery()
        for k in listeners.keys {
            listeners[k]?(level, state, k)
        }
    }
    
    private func logBattery() {
        eblog?("batteryDidChange: \(state.string) \(level)")
//        ebspeak("battery \(state.string) \(Int(100*level))%")
    }
    
    func startMonitoring() {
        eblog?("BatteryMonitor.startMonitoring)")
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange(notification:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange(notification:)), name: UIDevice.batteryStateDidChangeNotification, object: nil)

    }
    
    func stopMonitoring() {
        eblog?("BatteryMonitor.stopMonitoring")
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
    
}
