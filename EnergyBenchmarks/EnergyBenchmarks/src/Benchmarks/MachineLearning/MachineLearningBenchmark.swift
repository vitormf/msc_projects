//
//  MachineLearningBenchmark.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 08/11/22.
//

import UIKit

protocol MachineLearningBenchmark: Benchmark {
    var threads: Int { get }
    var threadsId: String { get }
    var repeats: UInt64 { get }
    func predict(thread:Int, image:UIImage, _ onCompletion:@escaping ([String])->())
}

private var queues = [DispatchQueue]()
private let qos = DispatchQoS.userInitiated
private var queuesCompleted = 0

extension MachineLearningBenchmark {
    var NUMBER_OF_RESULTS:Int {
        get { 5 }
    }
    var info: String { "x\(formatInt(repeats*UInt64(threads)))" }
    var identifier: String { "\(subidentifier) \(info)" }

    var subidentifier:String {
        get {"\(String(describing: self).components(separatedBy: ".")[1])(\(threadsId))"}
    }

    func setup() {
        queues.removeAll()
        queuesCompleted = 0
        for i in 0...threads {
            queues.append(DispatchQueue(label: "\(i)", qos: qos, autoreleaseFrequency: .workItem))
        }
        setupTinyImageNet()
//        setupImageNet()
    }

    func imagePreLoaded(_ index:UInt64) -> UIImage {
        return tinyImageNet[Int(index%TINY_IMAGENET_COUNT)]
    }

    func imageOnDemand(_ index:UInt64) -> UIImage {
        let imgIndex = Int(index%FULL_TINY_IMAGENET_COUNT)
        return UIImage(named: "tiny_imagenet/val_\(imgIndex).JPEG")! // TODO for imagenet
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
            queues[queue].async {
                recursiveExecute(complete: complete, index: 0, queue: queue)
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
                let image = imagePreLoaded(index)
                predict(thread: queue, image: image) { predictions in
                    queues[queue].async {
                        self.recursiveExecute(complete: complete, index: index+1, queue: queue)
                    }
                }
            }
        }
    }

}

protocol MachineLearningBenchmarkSynchronous: MachineLearningBenchmark, BenchmarkSynchronous {
    
}


