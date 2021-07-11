//
//  BatteryMonitor.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 19/06/21.
//

import UIKit

typealias BatteryMonitorReport = (Float, UIDevice.BatteryState) -> Void

class BatteryMonitor {
    
    static let shared = BatteryMonitor()
    
    var level:Float {
        UIDevice.current.batteryLevel
    };
    
    var state:UIDevice.BatteryState {
        UIDevice.current.batteryState
    }
    
    var report:BatteryMonitorReport?
    
    @objc
    func batteryLevelDidChange(notification: NSNotification) {
        log("batteryLevelDidChange: \(level)")
        report?(level, state)
    }

    @objc
    func batteryStateDidChange(notification: NSNotification) {
        log("batteryStateDidChange: \(state.string)")
        report?(level, state)
    }
    
    func startMonitoring() {
        log("BatteryMonitor.startMonitoring)")
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange(notification:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange(notification:)), name: UIDevice.batteryStateDidChangeNotification, object: nil)

    }
    
    func stopMonitoring() {
        log("BatteryMonitor.stopMonitoring")
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
    
}
