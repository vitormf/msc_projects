//
//  SqueezeNetTests.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor Maciel on 07/05/23.
//

import XCTest
@testable import EnergyBenchmarks


class SqueezeNetTests: MachineLearningTests {
    override func setUp() {
        benchmarks = [
            SqueezeNetCoreML(1),
            SqueezeNetTFLite(1),
            SqueezeNetTorch(1),
        ]
        super.setUp()
    }
}
