//
//  File.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 21/06/21.
//

import UIKit

public extension UIDevice.BatteryState {
    var string:String {
        get {
            var value = ""
            
            switch self {
            case .charging:
                value = "charging"
            case .full:
                value = "full"
            case .unplugged:
                value = "unplugged"
            default:
                value = "unknown"
                
            }
            
            return value
        }
    }
}
