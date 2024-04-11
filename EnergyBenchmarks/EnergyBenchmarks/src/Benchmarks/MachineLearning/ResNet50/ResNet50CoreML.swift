//
//  MobileNetCoreML.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 09/04/23.
//

import Foundation
import Vision

class ResNet50CoreML: ResNet50Benchmark, CoreMLVisionBenchmark {
    var visionModel: VNCoreMLModel
    var repeats:UInt64
    var threads:Int

    var threadsId:String {
        get { String(threads) }
    }

    init(_ threads:Int) {
        visionModel = try! VNCoreMLModel(for: Resnet50_apple(configuration: MLModelConfiguration()).model)
        self.threads = threads
        repeats = resNetCalculateRepeats(threads)
    }
}
