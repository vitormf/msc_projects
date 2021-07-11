//
//  BenchmarkResult.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 22/06/21.
//

import Foundation
import DeviceKit


class BenchmarkResult {
    
    var category:String
    var identifier:String
    var battery:Float
    var duration:TimeInterval
    let system = "iOS"
    let model = Device.current.safeDescription
    let name = Device.current.name ?? "unknown"
    let cores = ProcessInfo.processInfo.activeProcessorCount
    let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
    
    init(category:String, identifier:String, battery:Float, duration:TimeInterval) {
        self.category = category
        self.identifier = identifier
        self.battery = battery
        self.duration = duration
        
    }
    
}
