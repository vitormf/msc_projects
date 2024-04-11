//
//  MobileNetTF2ML.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 09/04/23.
//

import Foundation
import Vision

class ResNet50TF2ML: ResNet50CoreML {

    override init(_ threads: Int) {
        super.init(threads)
        visionModel = try! VNCoreMLModel(for: try! tf_to_coreml_resnet50(configuration: MLModelConfiguration()).model)
    }

}
