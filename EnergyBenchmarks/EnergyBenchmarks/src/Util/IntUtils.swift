//
//  IntUtils.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 07/08/21.
//

import Foundation


func intIdFormat(_ value:UInt64) -> String{
    if value / 1_000_000_000 > 0 {
        return "\(value / 1_000_000_000)G"
    } else if value / 1_000_000 > 0 {
        return "\(value / 1_000_000)M"
    } else if value / 1_000 > 0 {
        return "\(value / 1_000)K"
    } else {
        return "\(value)"
    }
}
