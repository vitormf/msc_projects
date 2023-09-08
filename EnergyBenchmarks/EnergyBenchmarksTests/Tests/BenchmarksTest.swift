//
//  BenchmarksTest.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor Maciel on 28/02/23.
//

import XCTest
@testable import EnergyBenchmarks

class BenchmarksTests: XCTestCase {

    func syncTest(benchmark:BenchmarkSynchronous) {
        benchmark.setup()
        benchmark.execute()
    }

    func asyncTest(benchmark:Benchmark) {
        let expectation = XCTestExpectation()
        benchmark.setup()
        benchmark.execute {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3600)
    }


    func testMobileNetCoreML() {
        asyncTest(benchmark: MobileNetV2CoreML(1))
    }

    func testMobileNetCoreML16() {
        asyncTest(benchmark: MobileNetV2CoreML(16))
    }

    func testMobileNetTFLite() {
        asyncTest(benchmark: MobileNetV2TFLite(1))
    }

    func testMobileNetTFLite16() {
        asyncTest(benchmark: MobileNetV2TFLite(16))
    }

    func testMobileNetCoreMLConverted() {
        asyncTest(benchmark: MobileNetV2TF2ML(1))
    }

    func testMobileNetV2TFLite_internal() {
        asyncTest(benchmark: MobileNetV2TFLite_internal(1))
    }

    func testMobileNetTF2TFLite() {
        asyncTest(benchmark: MobileNetV2TF2TFLite(1))
    }

    func testMobileNetTorch() {
        asyncTest(benchmark: MobileNetV2Torch(1))
    }
    
    func testMobileNetTorch4() {
        asyncTest(benchmark: MobileNetV2Torch(4))
    }
    
    func testTorchSimple() {
        let expectation = XCTestExpectation()
        let image = UIImage(named: "tree.jpg")!
        let torch = MobileNetV2Torch(1)
        torch.setup()
        torch.predict(thread: 0, image: image) { predictions in
            print("### FINISHED \(predictions)")
            expectation.fulfill()
        }
        wait(for: [expectation])
    }

    func testSqueezeNetCoreML() {
        asyncTest(benchmark: SqueezeNetCoreML(1))
    }
    
    func testBertCoreML1() {
        asyncTest(benchmark: BertCoreML(1))
    }

    func testBertCoreML2() {
        asyncTest(benchmark: BertCoreML(2))
    }

    func testBertTFLite1() {
        asyncTest(benchmark: BertTFLite(1))
    }

}
