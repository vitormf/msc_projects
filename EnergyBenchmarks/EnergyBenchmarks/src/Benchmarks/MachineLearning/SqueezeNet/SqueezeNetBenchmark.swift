//
//  SqueezeNet.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 07/05/23.
//

import Foundation
import UIKit
import DeviceKit

let allSqueezeNetBenchmarks:[Benchmark] = [
    SqueezeNetCoreML(1),
    SqueezeNetCoreML(2),
    SqueezeNetCoreML(4),
    SqueezeNetCoreML(6),
    SqueezeNetCoreML(8),
    SqueezeNetCoreML(16),
    SqueezeNetTFLite(1),
    SqueezeNetTFLite(2),
    SqueezeNetTFLite(4),
    SqueezeNetTFLite(6),
    SqueezeNetTFLite(8),
    SqueezeNetTFLite(16),
//    SqueezeNetTF2ML(1),
//    SqueezeNetTF2ML(2),
//    SqueezeNetTF2ML(4),
//    SqueezeNetTF2ML(6),
//    SqueezeNetTF2ML(8),
//    SqueezeNetTF2ML(16),
//    SqueezeNetTFLite_internal(1),
//    SqueezeNetTFLite_internal(2),
//    SqueezeNetTFLite_internal(4),
//    SqueezeNetTFLite_internal(6),
//    SqueezeNetTF2TFLite(1),
//    SqueezeNetTF2TFLite(2),
//    SqueezeNetTF2TFLite(4),
//    SqueezeNetTF2TFLite(6),
    ]

func squeezeNetCalculateRepeats(_ threads:Int) -> UInt64 {
    return squeezeNetTotalRepeats()/UInt64(threads)
}

private func squeezeNetTotalRepeats() -> UInt64 {
    switch(Device.current) {
    case .iPhone8Plus:
        return 50_000
    case .iPadAir4:
        return 250_000
    default:
        return 0
    }
}



protocol SqueezeNetBenchmark: MachineLearningBenchmark {

    var repeats:UInt64 { get }
    var threads:Int { get }
    var threadsId:String { get }

}

extension SqueezeNetBenchmark {
    var category: String { "L_SqueezeNet" }

    var subidentifier:String {
        get {"\(String(describing: self).components(separatedBy: ".")[1])(\(threadsId))"}
    }

}
