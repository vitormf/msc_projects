//
//  MobileNetV2TFLite-internal.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 09/04/23.
//

import Foundation
import DeviceKit

class MobileNetV2TFLite_internal: MobileNetV2TFLite {

    private let _internalThreads:Int
    override var internalThreads:Int {
        get { _internalThreads }
    }

    override var threadsId:String {
        get { String(_internalThreads) }
    }

    override init(_ threads: Int) {
        _internalThreads = threads
        super.init(1)
    }
}
