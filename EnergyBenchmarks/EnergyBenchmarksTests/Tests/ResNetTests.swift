//
//  ResNetTests.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor Maciel on 09/05/23.
//

import XCTest
@testable import EnergyBenchmarks


class ResNetTests: MachineLearningTests {
    override func setUp() {
        benchmarks = [
            ResNet50CoreML(1),
            ResNet50TF2ML(1),
            ResNet50TF2TFLite(1),
            ResNet50Torch(1),
        ]
        super.setUp()
    }
}
