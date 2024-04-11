//
//  CoreMLBertBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 05/07/2023.
//

import Foundation

class BertCoreML: BertBenchmark {
    var bert:[BERT] = []
    
    override func setup() {
        super.setup()
        for _ in 0...threads {
            bert.append(BERT())
        }
    }
    
    override func predict(thread:Int, _ onCompletion:@escaping ([String])->()) {
        let answer = String(bert[thread].findAnswer(for: question, in: document))
        onCompletion([answer])
    }
}
