//
//  Log.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 22/06/21.
//

import Foundation

var printLog = true

func log(_ message:String) {
    if printLog {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH'h'mm'm'ss's'"
        let now = formatter.string(from: Date())
        print("EBLOG[\(now)]: \(message)")
    }
}
