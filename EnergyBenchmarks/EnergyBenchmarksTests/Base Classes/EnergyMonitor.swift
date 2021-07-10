//
//  EnergyMonitor.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 19/06/21.
//

import UIKit

typealias EnergyMonitorReport = (Float, UIDevice.BatteryState) -> Void

class EnergyMonitor {
    
    static let shared = EnergyMonitor()
    
    var level:Float {
        UIDevice.current.batteryLevel
    };
    
    var state:UIDevice.BatteryState {
        UIDevice.current.batteryState
    }
    
    var report:EnergyMonitorReport?
    
    @objc
    func batteryLevelDidChange(notification: NSNotification) {
        etdebug("batteryLevelDidChange: \(level)")
        report?(level, state)
    }

    @objc
    func batteryStateDidChange(notification: NSNotification) {
        etdebug("batteryStateDidChange: \(state.string)")
        report?(level, state)
    }
    
    func startMonitoring() {
        etdebug("startMonitoring: \(UIDevice.current.batteryLevel) \(UIDevice.current.batteryState.string)")
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange(notification:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange(notification:)), name: UIDevice.batteryStateDidChangeNotification, object: nil)

    }
    
    func stopMonitoring() {
        etdebug("stopMonitoring: \(UIDevice.current.batteryLevel) \(UIDevice.current.batteryState.string)")
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
    
}
