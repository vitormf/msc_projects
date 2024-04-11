//
//  TFLiteVisionBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 07/05/23.
//

import Foundation
import TensorFlowLiteTaskVision

protocol TFLiteVisionBenchmark: MachineLearningBenchmark {
    var classifiers: [ImageClassifier] { get }

}

extension TFLiteVisionBenchmark {
    func loadClassifier(fileName: String, threadCount: Int, resultCount: Int, scoreThreshold: Float) -> ImageClassifier {
        let modelPath = Bundle.main.path(forResource: fileName, ofType: "tflite")!
        let options = ImageClassifierOptions(modelPath: modelPath)
        options.baseOptions.computeSettings.cpuSettings.numThreads = threadCount
        options.classificationOptions.maxResults = resultCount
        options.classificationOptions.scoreThreshold = scoreThreshold
        return try! ImageClassifier.classifier(options: options)
    }

    func classify(_ thread:Int, _ image: UIImage) -> Classifications {
        let classifier = classifiers[thread]
        let mlImage = MLImage(image: image)!
        let classificationResults = try! classifier.classify(mlImage: mlImage)
        return classificationResults.classifications.first!
    }

    func predict(thread:Int, image:UIImage, _ onCompletion: @escaping ([String]) -> ()) {
        let classifications = classify(thread, image)
        let predictions:[String] = classifications.categories.map { c in c.label ?? "" }
        onCompletion(predictions)
    }
}
