//
//  BenchmarkResult.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 22/06/21.
//

import Foundation
import DeviceKit


class BenchmarkResult {
    
    let timestamp:UInt64
    let category:String
    let identifier:String
    let info:String
    let battery:UInt
    let duration:TimeInterval
    let os:String
    let osVersion:String
    let model:String
    let name:String
    let cores:Int
    
    init(
        timestamp:UInt64 = UInt64(Date().timeIntervalSince1970),
        category:String,
        identifier:String,
        info:String,
        battery:UInt,
        duration:TimeInterval,
        os:String = "iOS",
        osVersion:String = Device.current.systemVersion ?? "unknown",
        model:String = Device.current.safeDescription,
        name:String = Device.current.name ?? "unknown",
        cores:Int = ProcessInfo.processInfo.activeProcessorCount) {
        
        self.timestamp = timestamp
        self.category = category
        self.identifier = identifier
        self.info = info
        self.battery = battery
        self.duration = duration
        self.os = os
        self.osVersion = osVersion
        self.model = model
        self.name = name
        self.cores = cores
    }
    
}
