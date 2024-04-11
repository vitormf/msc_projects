//
//  Resnet50TorchGPU.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 23/08/2023.
//

import Foundation
import UIKit

class ResNet50TorchGPU: ResNet50Benchmark, PyTorchVisionBenchmark {
    
    let moduleFile = "resnet_quantized" // libtorch
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
        repeats = resNetCalculateRepeats(threads)
        
        for _ in 0...threads {
            imagePredictors.append(ImagePredictor(moduleFile: moduleFile))
        }
    }
    
    func predict(thread: Int, image: UIImage, _ onCompletion: @escaping ([String]) -> ()) {
        predictGPU(thread: thread, image: image, onCompletion)
    }
    
}
