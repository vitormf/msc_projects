//
//  MobileNetTFLite.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 09/04/23.
//

import Foundation
import TensorFlowLiteTaskVision

// NOT AVAILABLE
class ResNet50TFLite: ResNet50Benchmark, TFLiteVisionBenchmark {
    var repeats:UInt64
    var threads:Int

    var threadsId:String {
        get { String(threads) }
    }

    var modelFileName:String {
        get {"mobilenet_v2_quant_metadata"} // NOT AVAILABLE
    }

    var internalThreads:Int {
        get { 4 }
    }

    let maxResults = 5
    let scoreThreshold: Float = 0.2

    var classifiers = [ImageClassifier]()

    init(_ threads:Int) {
        self.threads = threads
        repeats = resNetCalculateRepeats(threads)

        for _ in 0...threads {
            classifiers.append(
                loadClassifier(
                    fileName: modelFileName,
                    threadCount: internalThreads,
                    resultCount: NUMBER_OF_RESULTS,
                    scoreThreshold: scoreThreshold
                )
            )
        }
    }
}
