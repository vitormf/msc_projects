//
//  MachineLearningMobileNetBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 08/11/22.
//

import Foundation
import UIKit
import DeviceKit

let allResNetBenchmarks:[Benchmark] = [
    ResNet50CoreML(1),
    ResNet50CoreML(2),
    ResNet50CoreML(4),
    ResNet50CoreML(6),
    ResNet50CoreML(8),
    ResNet50CoreML(16),
    ResNet50TF2ML(1),
    ResNet50TF2ML(2),
    ResNet50TF2ML(4),
    ResNet50TF2ML(6),
    ResNet50TF2ML(8),
    ResNet50TF2ML(16),
    ResNet50TF2TFLite(1),
    ResNet50TF2TFLite(2),
    ResNet50TF2TFLite(4),
    ResNet50TF2TFLite(6),
    ResNet50TF2TFLite(8),
    ResNet50TF2TFLite(16),
    ResNet50Torch(1),
    ResNet50Torch(2),
    ResNet50Torch(4),
    ResNet50Torch(6),
    ResNet50Torch(8),
    ResNet50Torch(16),
    ResNet50TorchGPU(1),
    ResNet50TorchGPU(2),
    ResNet50TorchGPU(4),
    ResNet50TorchGPU(6),
    ResNet50TorchGPU(8),
    ResNet50TorchGPU(16),

    // DISABLE TFLITE
    //    ResNet50TFLite(1),
    //    ResNet50TFLite(2),
    //    ResNet50TFLite(4),
    //    ResNet50TFLite(6),
    //    ResNet50TFLite(8),
    //    ResNet50TFLite(16),
    // DISABLE TFLITE INTERNAL
    //    ResNet50TFLite_internal(1),
    //    ResNet50TFLite_internal(2),
    //    ResNet50TFLite_internal(4),
    //    ResNet50TFLite_internal(6),
    
]

func resNetCalculateRepeats(_ threads:Int) -> UInt64 {
    return resNetTotalRepeats()/UInt64(threads)
}

private func resNetTotalRepeats() -> UInt64 {
    return BenchmarkRepeat.resNet50.total
}



protocol ResNet50Benchmark: MachineLearningBenchmark {
    
    var repeats:UInt64 { get }
    var threads:Int { get }
    var threadsId:String { get }
    
}

extension ResNet50Benchmark {
    var category: String { currentImageNetDataSet.preffix + "ResNet" }
    
    
    var subidentifier:String {
        get {"\(String(describing: self).components(separatedBy: ".")[1])(\(threadsId))"}
    }
    
}
