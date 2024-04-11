//
//  MobileNetV2Torch.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 12/07/2023.
//

import Foundation
import UIKit

class MobileNetV2Torch: MobileNetBenchmark, PyTorchVisionBenchmark {
    
    let moduleFile = "mobilenet_quantized" // libtorch
//    let moduleFile = "model" // libtorch-lite-nightly
    
    var imagePredictors = [ImagePredictor]()
    var repeats:UInt64
    var threads:Int
    var errorCount:Int = 0
    
    var threadsId:String {
        get { String(threads) }
    }
    
    init(_ threads:Int) {
        
        self.threads = threads
        repeats = mobileNetCalculateRepeats(threads)
        
        for _ in 0...threads {
            imagePredictors.append(ImagePredictor(moduleFile: moduleFile))
        }
    }
    
    func predict(thread: Int, image: UIImage, _ onCompletion: @escaping ([String]) -> ()) {
        predictCPU(thread: thread, image: image, onCompletion)
    }
    
}
