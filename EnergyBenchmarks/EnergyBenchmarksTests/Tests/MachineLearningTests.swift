//
//  MachineLearningTests.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor Maciel on 23/08/2023.
//

import XCTest
@testable import EnergyBenchmarks

class MachineLearningTests: XCTestCase {
    var benchmarks:Array<MachineLearningBenchmark>!
    
    override func setUp() {
        benchmarks[0].setup()
    }
    
    
    //    func testMobileNetSimilarity() {
    //        let total = TINY_IMAGENET_COUNT
    //
    //        var similaritySum = 0.0
    //        for i in 0...total {
    //            print("\(i)/\(total)")
    //            let image = benchmarks[0].imagePreLoaded(i)
    //            similaritySum += mobileNetSimilarity(image: image)
    //        }
    //
    //        let similarityAverage = similaritySum/Double(total)
    //        print("#######################\nsimilarityAverage: \(similarityAverage)")
    //
    //    }
    //
    //    func mobileNetSimilarity(image:UIImage) -> Double {
    //        let expectation = XCTestExpectation()
    //        var similarity = 0.0
    //
    //        self.coreML.predict(thread:0, image: image) { coreMLPredictions in
    //            self.tfLite.predict(thread:0, image: image) { tfLitePredictions in
    //                let similarPred = Set(coreMLPredictions).intersection(tfLitePredictions)
    //                similarity = Double(similarPred.count)/Double(coreMLPredictions.count)
    //                expectation.fulfill()
    //            }
    //        }
    //        wait(for: [expectation], timeout: 10)
    //        return similarity
    //    }
        

        func testAccuracy() {
            let total = TINY_IMAGENET_COUNT
            var counts = [String:Int]()
            
            func printAverages() {
                print("#######################")
                benchmarks.forEach { benchmark in
                    let identifier = benchmark.identifier
                    let count = counts[identifier] ?? 0
                    let average = Double(count)/Double(total)
                    print("\(benchmark.identifier) average: \(average)")
                }
                print("#######################")
            }
            
            for i:UInt64 in 0...total {
                autoreleasepool {
                    benchmarks.forEach { benchmark in
                        if (machineLearningTest(benchmark: benchmark, index: i)) {
                            let identifier = benchmark.identifier
                            let count = counts[identifier] ?? 0
                            counts[identifier] = count+1
                        }
                    }
                }
                print("\(i)/\(total)")
            }
            printAverages()

        }

        func machineLearningTest(benchmark:MachineLearningBenchmark,index:UInt64) -> Bool {
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
        
        
        func testFindPerfectMatchImages() {
            let total = TINY_IMAGENET_COUNT
            var perfectMatches = [UInt64]()

            for i in 0...total {
                autoreleasepool {
                    var perfectMatch = true
                    for benchmark in benchmarks {
                        if (!machineLearningTest(benchmark: benchmark, index: i)) {
                            perfectMatch = false
                            break
                        }
                    }
                    if (perfectMatch) {
                        perfectMatches.append(i)
                        print("Perfect Match: \(i)")
                    }
                }
            }
            print("All matches: \(perfectMatches)")
            print("All matches count: \(perfectMatches.count)")
        }
    
}
