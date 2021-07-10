//
//  TestReport.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 22/06/21.
//

import UIKit


class TestReport {
    
    static func publishReport(identifier:String, battery:Float, duration:TimeInterval) {
        let model = UIDevice.modelName
        let cores = ProcessInfo.processInfo.activeProcessorCount
        let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
        
        print("######## REPORT Id: \(identifier) - Battery: \(battery) - duration: \(duration) - device: \(model) - cores: \(cores) - osVersion: \(osVersion)")
    }
    
}
