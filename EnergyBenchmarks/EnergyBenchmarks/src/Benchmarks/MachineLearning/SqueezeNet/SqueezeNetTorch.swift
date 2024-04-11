//
//  SqueezeNetTorch.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 24/08/2023.
//

import Foundation
import UIKit

class SqueezeNetTorch: SqueezeNetBenchmark, PyTorchVisionBenchmark {
    
    let moduleFile = "new_squeezenet1_0" // libtorch
    
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
        predictCPU(thread: thread, image: image, onCompletion)
    }
    
}
