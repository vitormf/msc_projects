//
//  BertTests.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor Maciel on 05/07/2023.
//

import XCTest
@testable import EnergyBenchmarks

class BertTests: XCTestCase {
    let coreML = ResNet50CoreML(1)
//    let tfLite = ResNet50TFLite(1)
//    let tf2ml = ResNet50TF2ML(1)
//    let tf2tfLite = ResNet50TF2TFLite(1)
//    let tfLiteInternal = SqueezeNetTFLite_internal(1)

    override func setUp() {
        coreML.setup()
    }

    func testAccuracy() {
        let total = TINY_IMAGENET_COUNT
        var coreMLCount = 0
        var tfLiteCount = 0
        var tf2mlCount = 0
        var tf2tfLiteCount = 0

        for i:UInt64 in 0...total {
            autoreleasepool {
                if (resNetTest(benchmark: coreML, index: i)) {
                    coreMLCount += 1
                }
//                if (resNetTest(benchmark: tfLite, index: i)) {
//                    tfLiteCount += 1
//                }
//                if (resNetTest(benchmark: tf2ml, index: i)) {
//                    tf2mlCount += 1
//                }
//                if (resNetTest(benchmark: tf2tfLite, index: i)) {
//                    tf2tfLiteCount += 1
//                }
//                print("\(i)/\(total) - \(Double(coreMLCount)/Double(i)) / \(Double(tfLiteCount)/Double(i)) / \(Double(tf2mlCount)/Double(i)) / \(Double(tf2tfLiteCount)/Double(i))")
            }
        }
        print("#######################\n coreML average: \(Double(coreMLCount)/Double(total))")
        print("#######################\n tfLite average: \(Double(tfLiteCount)/Double(total))")
        print("#######################\n tf2ml average: \(Double(tf2mlCount)/Double(total))")
        print("#######################\n tf2tfLite average: \(Double(tf2tfLiteCount)/Double(total))")

    }

    func resNetTest(benchmark:ResNet50Benchmark,index:UInt64) -> Bool {
        let expectation = XCTestExpectation()
        var found = false

        let image = benchmark.imagePreLoaded(UInt64(index))
        benchmark.predict(thread:0, image: image) { predictions in
//            print("\(type(of: benchmark)) - \(ImageLabels.tinyImageNetLabels[Int(index)]) : \(predictions)")
//            let label = ImageLabels.tinyImageNetLabels[Int(index)]
            let label = ImageLabels.imageNetLabels[Int(index)]
            found = self.matches(predictions: predictions, labelsString: label)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        return found
    }

    func matches(predictions:[String], labelsString:String) -> Bool {
        let labels = labelsString.split(separator: ",").map { s in
            String(s).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        for prediction in predictions {
            if labels.contains(prediction) {
                return true
            }
        }
        return false
    }
}
