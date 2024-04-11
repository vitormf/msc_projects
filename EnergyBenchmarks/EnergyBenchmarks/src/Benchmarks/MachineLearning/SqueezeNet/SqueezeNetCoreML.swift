//
//  SqueezeNetCoreML.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 07/05/23.
//

import Foundation
import UIKit
import Vision

class SqueezeNetCoreML: SqueezeNetBenchmark, CoreMLVisionBenchmark {
    var visionModel: VNCoreMLModel
    var repeats:UInt64
    var threads:Int

    var threadsId:String {
        get { String(threads) }
    }

    init(_ threads:Int) {
        visionModel = try! VNCoreMLModel(for: SqueezeNet_apple(configuration: MLModelConfiguration()).model)
        self.threads = threads
        repeats = squeezeNetCalculateRepeats(threads)
    }
}
