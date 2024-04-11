//
//  MobileNetTF2TFLite.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 21/04/23.
//

import Foundation


class MobileNetV2TF2TFLite: MobileNetV2TFLite {
    override var modelFileName:String {
        get {"keras_mobilenet_v2_with_metadata"}
    }
}
