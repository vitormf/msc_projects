//
//  EnergyTestDebug.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 22/06/21.
//

import Foundation

var energyTestDebug = true


func etdebug(_ message:String) {
    if energyTestDebug {
        print(message)
    }
}
