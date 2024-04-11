//
//  BertTests.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor Maciel on 05/07/2023.
//

import XCTest
@testable import EnergyBenchmarks

class BertTests: XCTestCase {
    var bertDataset = BertDataset()

    override func setUp() {
        bertDataset.parse()
    }

    func testAccuracy() {
        let coreML = BERT()
        let tfLite = try! BertQAHandler(threadCount: 4)
        
        var questionsCount = 0
        var coreMLMatch = 0
        var tfLiteMatch = 0
        
        let export = NSMutableArray()
        
        let start = CFAbsoluteTimeGetCurrent()
        
        for (i,text) in bertDataset.texts.enumerated() {
            if i == 200 {
                break;
            }
//            print("================")
//            print(text.context)
//            print("")
            let exportText = NSMutableDictionary()
            exportText["context"] = text.context
            
            let exportQuestions = NSMutableArray()
            for question in text.questions {
                questionsCount += 1
                let coreMLAnswer = coreML.findAnswer(for: question.question, in: text.context)
                let tfLiteAnswer = tfLite.run(query: question.question, content: text.context)? .answer.text.value
                
                let exportQuestion = NSMutableDictionary()
                exportQuestion["question"] = question.question
                exportQuestion["coreMLAnswer"] = coreMLAnswer
                exportQuestion["tfLiteAnswer"] = tfLiteAnswer
                exportQuestion["expected"] = question.answers
                exportQuestions.add(exportQuestion)
                
                if question.answers.contains(String(coreMLAnswer)) {
                    coreMLMatch += 1
                }
                if let tfLiteAnswer = tfLiteAnswer, question.answers.contains(tfLiteAnswer) {
                    tfLiteMatch += 1
                }
                
//                print(question.question)
//                print("coreML: \(coreMLAnswer)")
//                print("tfLite: \(tfLiteAnswer)")
//                print("expected: \(question.answers)")
//                print("")
            }
            
            exportText["questions"] = exportQuestions
            export.add(exportText)
            
            print("\(i)/\(bertDataset.texts.count) - Time: \(Int(CFAbsoluteTimeGetCurrent() - start)) - coreML: \(coreMLMatch)/\(questionsCount) - tfLite: \(tfLiteMatch)/\(questionsCount)")

        }

        
        print("questionsCount: \(questionsCount)")
        let jsonData = try! JSONSerialization.data(withJSONObject: export, options: .prettyPrinted)
        try! jsonData.write(to: URL(fileURLWithPath: "/Users/vitor/Desktop/bert_accuracies.json"))
    }

    
}
