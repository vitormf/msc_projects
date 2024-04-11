//
//  PyTorchVisionBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 8/11/23.
//

import UIKit


protocol PyTorchVisionBenchmark: MachineLearningBenchmark {
    var imagePredictors: [ImagePredictor] { get }
}

extension PyTorchVisionBenchmark {

    func predictCPU(thread:Int, image:UIImage, _ onCompletion:@escaping ([String])->()) {

        let imageBuffer = tinyImageNetBuffers[image]!
        let outputs:([InferenceResult], Double)? = try? imagePredictors[thread].predict(imageBuffer, resultCount: self.NUMBER_OF_RESULTS)
        let result = outputs?.0.map { inference in inference.label } ?? []
        onCompletion(result)
    }
    
    func predictGPU(thread:Int, image:UIImage, _ onCompletion:@escaping ([String])->()) {

        let imageBuffer = tinyImageNetBuffers[image]!
        let outputs:([InferenceResult], Double)? = try? imagePredictors[thread].predict(imageBuffer, resultCount: self.NUMBER_OF_RESULTS)
        let result = outputs?.0.map { inference in inference.label } ?? []
        onCompletion(result)
    }
}
