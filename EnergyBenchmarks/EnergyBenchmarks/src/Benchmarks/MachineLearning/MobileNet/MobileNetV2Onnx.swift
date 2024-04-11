//
//  MobileNetV2Onnx.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 08/09/2023.
//

import Foundation
import onnxruntime_objc

class MobileNetV2Onnx: MobileNetBenchmark {
    var repeats: UInt64
    
    var threads: Int
    
    var threadsId:String {
        get { String(threads) }
    }
    
    init(_ threads:Int) {
        
        self.threads = threads
        repeats = mobileNetCalculateRepeats(threads)
        
        for _ in 0...threads {
//            imagePredictors.append(ImagePredictor(moduleFile: moduleFile))
        }
    }
    
    func predict(thread: Int, image: UIImage, _ onCompletion: @escaping ([String]) -> ()) {
        
    }
    
    
}
