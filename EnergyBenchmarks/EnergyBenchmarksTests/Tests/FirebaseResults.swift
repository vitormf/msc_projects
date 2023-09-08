//
//  FirebaseResults.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor Maciel on 14/08/2023.
//


import XCTest
@testable import EnergyBenchmarks

import FirebaseDatabase

class FirebaseResults: XCTestCase {
    
    
    func testGetResults() {
        self.continueAfterFailure = false
        let expectation = XCTestExpectation()
        
        var output = ""
        
        DispatchQueue.main.async {
            output.append("category,identifier,model,count,battery,duration\n")
            let ref = ReportService.results()
            ref.getData { error, snapshot in
                let value = snapshot?.value as? NSDictionary
                XCTAssertNotNil(value, "error fetching firebase data")
//                print("value \(value)")
                value!.forEach { category, identifiers in
                    (identifiers as! NSDictionary).forEach { identifier, models in
                        (models as! NSDictionary).forEach { model, timestamps in
                            var results = [BenchmarkResult]()
                            (timestamps as! NSDictionary).forEach { timestamp, resultDict in
                                let result = ReportService.result(value: resultDict as! NSDictionary)
                                results.append(result)
                            }
                            
                            let count = results.count
                            let battery = results.map{ r in Int(r.battery) }.reduce(0, +) / count
                            let duration = results.map{ r in Double(r.duration) }.reduce(0, +) / Double(count)
                            let formatter = DateComponentsFormatter()
                            formatter.allowedUnits = [.hour, .minute, .second]
                            formatter.zeroFormattingBehavior = .pad
                            let durationStr = formatter.string(from: duration)!
                            output.append("\(category),\"\(identifier)\",\(model),\(results.count),\(battery),\(durationStr)\n")
                        }
                    }
                }
                print("##################################")
                print("\(output)")
                print("##################################")
                
                try! output.write(toFile: "/Users/vitor/Desktop/benchmarks.csv", atomically: true, encoding: .utf8)
                expectation.fulfill()
            }
        }
        
        
        wait(for:[expectation], timeout: 10)
    }
    
    
    func result(dict:NSDictionary) -> BenchmarkResult? {
        return ReportService.result(value: dict)
    }
    
    
}
