//
//  BenchmarkProtocol.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 10/07/21.
//

import Foundation

typealias BenchmarkBlock = ()->Void

protocol Benchmark {
    var category:String { get }
    var identifier:String { get }
    var info:String { get }

    func setup()
    func execute(complete:@escaping BenchmarkBlock)
    func validate()
}

extension Benchmark {
    func setup(){}
}

protocol BenchmarkSynchronous: Benchmark {
    func execute()
}

extension BenchmarkSynchronous {
    func execute(complete:BenchmarkBlock) {
        execute()
        complete()
    }
}

extension Benchmark {
    func validate() {}
}


