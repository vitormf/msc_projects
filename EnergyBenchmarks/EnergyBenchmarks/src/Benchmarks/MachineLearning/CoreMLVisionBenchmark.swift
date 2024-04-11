//
//  CoreMLVisionBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 07/05/23.
//

import Foundation
import UIKit
import Vision

protocol CoreMLVisionBenchmark: MachineLearningBenchmark {
    var visionModel: VNCoreMLModel { get }
}

extension CoreMLVisionBenchmark {

    func predict(thread:Int, image:UIImage, _ onCompletion:@escaping ([String])->()) {

        let request = VNCoreMLRequest(model: visionModel) { request, error in
            guard let observations = request.results as? [VNClassificationObservation] else {
                eblog?("VNRequest produced the wrong result type: \(type(of: request.results)).")
                return
            }

            let predictions = observations.prefix(self.NUMBER_OF_RESULTS).map({ obs in
                String(obs.identifier.split(separator: ",").first ?? "")
            })
//            let predictions = observations.prefix(self.NUMBER_OF_RESULTS).map { String($0.identifier) }
            onCompletion(predictions)

        }
//        request.imageCropAndScaleOption = .centerCrop

        let handler = VNImageRequestHandler(
            cgImage: image.cgImage!,
            orientation: CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!
        )

        try? handler.perform([request])
    }
}
