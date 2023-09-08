//
//  IntFormatter.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 14/07/21.
//

import Foundation

func formatInt(_ value:UInt64) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value:value)) ?? ""
}
