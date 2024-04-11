//
//  BertBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 05/07/2023.
//

import Foundation
import DeviceKit

let allBertBenchmarks = [
    BertCoreML(1),
    BertCoreML(2),
    BertCoreML(4),
    BertCoreML(6),
    BertCoreML(8),
    BertCoreML(16),
    BertTFLite(1),
    BertTFLite(2),
    BertTFLite(4),
    BertTFLite(6),
    BertTFLite(8),
    BertTFLite(16),
    BertTFLiteInternal(1),
    BertTFLiteInternal(2),
    BertTFLiteInternal(4),
    BertTFLiteInternal(6),
    BertTFLiteInternal(8),
    BertTFLiteInternal(16),
]

private func totalRepeats() -> UInt64 {
    return BenchmarkRepeat.bert.total
}

fileprivate func bertCalculateRepeats(_ threads:Int) -> UInt64 {
    return totalRepeats()/UInt64(threads)
}

class BertBenchmark: Benchmark {
    
    let document = "Machine learning (ML) is the scientific study of algorithms and statistical models that computer systems use to progressively improve their performance on a specific task. Machine learning algorithms build a mathematical model of sample data, known as \"training data\", in order to make predictions or decisions without being explicitly programmed to perform the task. Machine learning algorithms are used in the applications of email filtering, detection of network intruders, and computer vision, where it is infeasible to develop an algorithm of specific instructions for performing the task. Machine learning is closely related to computational statistics, which focuses on making predictions using computers. The study of mathematical optimization delivers methods, theory and application domains to the field of machine learning. Data mining is a field of study within machine learning, and focuses on exploratory data analysis through unsupervised learning.In its application across business problems, machine learning is also referred to as predictive analytics."
    
    let question = "What is Machine Learning?"
    
    var category: String = "Bert"
    
    var threads: Int
    var threadsId: String
    var repeats: UInt64
    
    private var queues = [DispatchQueue]()
    private let qos = DispatchQoS.userInitiated
    private var queuesCompleted = 0
    
    var info: String
    var identifier: String { "\(subidentifier) \(info)" }

    var subidentifier:String {
        get {"\(String(describing: self).components(separatedBy: ".")[1])(\(threadsId))"}
    }
    
    init(_ threads:Int) {
        self.info = "x\(formatInt(totalRepeats()))"
        self.threadsId = "\(threads)"
        self.threads = threads
        self.repeats = bertCalculateRepeats(threads)
    }

    func setup() {
        queues.removeAll()
        queuesCompleted = 0
        for i in 0...threads {
            queues.append(DispatchQueue(label: "\(i)", qos: qos, autoreleaseFrequency: .workItem))
        }
    }

    func printProgress(_ i:UInt64, _ thread:Int) {
        if logLevel.rawValue <= LogLevel.Info.rawValue {
            let progress = (i*100)/self.repeats
            eblogInfo?("\(thread): \(progress)%")
        }
    }

    private func goalString(_ value:UInt64) -> String{
        return intIdFormat(value)
    }

    func execute(complete:@escaping BenchmarkBlock) {
        for queue in 0...threads-1 {
            queues[queue].async { [weak self] in
                self?.recursiveExecute(complete: complete, index: 0, queue: queue)
            }
        }
    }

    func recursiveExecute(complete:@escaping BenchmarkBlock, index:UInt64, queue:Int) {
        if (index == repeats) {
            queuesCompleted += 1
            if (queuesCompleted == threads) {
                complete()
            }
        } else {
            if index % (repeats/100) == 0 {
                printProgress(index, queue)
            }
            autoreleasepool {
                predict(thread: queue) { [weak self] predictions in
                    self?.queues[queue].async {
                        self?.recursiveExecute(complete: complete, index: index+1, queue: queue)
                    }
                }
            }
        }
    }
    

    
    func predict(thread:Int, _ onCompletion:@escaping ([String])->()) {
        fatalError("Override this method!")
    }
}
