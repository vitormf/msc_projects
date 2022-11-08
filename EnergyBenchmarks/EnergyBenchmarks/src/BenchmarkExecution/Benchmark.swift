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
    
    func execute()
    func validate()
}

extension Benchmark {
    func validate() {}
}


let allBenchmarks:[Benchmark] = allArrayBenchmarks + allConcurrencyBenchmarks + allSleepBenchmarks
