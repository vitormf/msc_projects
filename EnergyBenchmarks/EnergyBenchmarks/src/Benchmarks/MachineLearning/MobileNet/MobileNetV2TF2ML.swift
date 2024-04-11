//
//  MobileNetTF2ML.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 09/04/23.
//

import Foundation
import Vision

class MobileNetV2TF2ML: MobileNetV2CoreML {

    override init(_ threads: Int) {
        super.init(threads)
        visionModel = try! VNCoreMLModel(for: try! ssd_mobilenet_v2_2(configuration: MLModelConfiguration()).model)
    }

}
