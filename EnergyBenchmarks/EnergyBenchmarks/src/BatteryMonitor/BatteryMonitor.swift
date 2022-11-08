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
        logBattery()
        report?(level, state)
    }

    @objc
    func batteryStateDidChange(notification: NSNotification) {
        logBattery()
        report?(level, state)
    }
    
    private func logBattery() {
        eblog?("batteryDidChange: \(state.string) \(level)")
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
