//
//  MachineLearningMobileNetBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 08/11/22.
//

import Foundation
import UIKit
import DeviceKit

let allMobileNetBenchmarks:[Benchmark] = [
    MobileNetV2CoreML(1),
    MobileNetV2CoreML(2),
    MobileNetV2CoreML(4),
    MobileNetV2CoreML(6),
    MobileNetV2CoreML(8),
    MobileNetV2CoreML(16),
    MobileNetV2TFLite(1),
    MobileNetV2TFLite(2),
    MobileNetV2TFLite(4),
    MobileNetV2TFLite(6),
    MobileNetV2TFLite(8),
    MobileNetV2TFLite(16),
    MobileNetV2TF2ML(1),
    MobileNetV2TF2ML(2),
    MobileNetV2TF2ML(4),
    MobileNetV2TF2ML(6),
    MobileNetV2TF2ML(8),
    MobileNetV2TF2ML(16),
    MobileNetV2TFLite_internal(1),
    MobileNetV2TFLite_internal(2),
    MobileNetV2TFLite_internal(4),
    MobileNetV2TFLite_internal(6),
    MobileNetV2TF2TFLite(1),
    MobileNetV2TF2TFLite(2),
    MobileNetV2TF2TFLite(4),
    MobileNetV2TF2TFLite(6),
    MobileNetV2Torch(1),
    MobileNetV2Torch(2),
    MobileNetV2Torch(4),
    MobileNetV2Torch(6),
    MobileNetV2Torch(8),
    MobileNetV2Torch(16),
    MobileNetV2TorchGPU(1),
    MobileNetV2TorchGPU(2),
    MobileNetV2TorchGPU(4),
    MobileNetV2TorchGPU(6),
    MobileNetV2TorchGPU(8),
    MobileNetV2TorchGPU(16),
    ]

func mobileNetCalculateRepeats(_ threads:Int) -> UInt64 {
    return mobileNetTotalRepeats()/UInt64(threads)
}

private func mobileNetTotalRepeats() -> UInt64 {
    switch(Device.current) {
    case .iPhone8Plus:
        return 140_000
//        return 100_000
    case .iPadAir4:
        return 900_000
//        return 700_000
    default:
        return 0
    }
}



protocol MobileNetBenchmark: MachineLearningBenchmark {

    var repeats:UInt64 { get }
    var threads:Int { get }
    var threadsId:String { get }

}

extension MobileNetBenchmark {
    var category: String { "L_MobileNetV2" }


    var subidentifier:String {
        get {"\(String(describing: self).components(separatedBy: ".")[1])(\(threadsId))"}
    }

}
