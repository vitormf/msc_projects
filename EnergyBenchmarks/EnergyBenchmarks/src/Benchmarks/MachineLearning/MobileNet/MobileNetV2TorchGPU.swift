//
//  MobileNetV2TorchGPU.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 14/08/2023.
//

import UIKit

class MobileNetV2TorchGPU: MobileNetV2Torch {
    override func predict(thread: Int, image: UIImage, _ onCompletion: @escaping ([String]) -> ()) {
        self.predictGPU(thread: thread, image: image, onCompletion)
    }
}
