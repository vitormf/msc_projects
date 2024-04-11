//
//  BertTFLite.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 05/07/2023.
//

import Foundation

class BertTFLite: BertBenchmark {
    var bert:[BertQAHandler] = []
    var internalThreads:Int
    
    init(_ threads: Int, internalThreads:Int = 4) {
        self.internalThreads = internalThreads
        super.init(threads)
    }
    
    override func setup() {
        super.setup()
        for _ in 0...threads {
            bert.append(try! BertQAHandler(threadCount: internalThreads))
        }
    }
    
    override func predict(thread: Int, _ onCompletion: @escaping ([String]) -> ()) {
        let result = bert[thread].run(query: question, content: document)
        let answer = result?.answer.text.value
        onCompletion(answer != nil ? [answer!] : [])
    }
}


class BertTFLiteInternal: BertTFLite {
    init(_ internalThreads: Int) {
        super.init(1, internalThreads: internalThreads)
        self.threadsId = "\(internalThreads)"
    }
    
}
