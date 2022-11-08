//
//  BenchmarkExecutionSuite.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 13/07/21.
//

import Foundation
import AVFoundation

typealias BenchmarkExecutionSuiteProgress = (_ completed:Bool, _ progress:Int,_ total:Int, _ result:BenchmarkResult)->()

class BenchmarkExecutionSuite {
    
    let synthesizer = AVSpeechSynthesizer()
    
    let benchmarks:[Benchmark]
    private var currentExecution:BenchmarkExecution?
    
    init(benchmarks:[Benchmark]) {
        self.benchmarks = benchmarks
    }
    
    func execute(progress:BenchmarkExecutionSuiteProgress?) {
        speak("Starting \(benchmarks.count) benchmarks")
        execute(benchmarks, progress: progress)
    }
    
    private func execute(_ benchmarks:[Benchmark], progress:BenchmarkExecutionSuiteProgress?) {
        guard let first = benchmarks.first else {return}
        currentExecution = BenchmarkExecution(first)
        currentExecution?.execute { [weak self] benchmark,result in
            guard let self = self else {return}
            self.execute(Array(benchmarks.dropFirst()), progress: progress)
            
            let total = self.benchmarks.count
            let current = total - benchmarks.count + 1
            let completed = current == total
            progress?(completed, current, total, result)
            
            self.speak("Benchmark \(current) \(result.identifier) finished")
            BenchmarkReport.add(result:result)
            if completed {
                self.speak("All benchmarks are completed!")
                BenchmarkReport.report()
            }
        }
    }
    
    private func speak(_ text:String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        synthesizer.speak(utterance)
    }
    
}
