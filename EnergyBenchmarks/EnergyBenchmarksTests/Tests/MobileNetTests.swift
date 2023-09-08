//
//  AccuracyTests.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor Maciel on 10/03/23.
//

import XCTest
@testable import EnergyBenchmarks

class MobileNetTests: MachineLearningTests {
    override func setUp() {
        benchmarks = [
            MobileNetV2CoreML(1),
            MobileNetV2TFLite(1),
            MobileNetV2TF2ML(1),
            MobileNetV2TF2TFLite(1),
            MobileNetV2TFLite_internal(1),
            MobileNetV2Torch(1),
            MobileNetV2TorchGPU(1),
        ]
        super.setUp()
    }
}
