//
//  MobileNetTF2TFLite.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 21/04/23.
//

import Foundation


class ResNet50TF2TFLite: ResNet50TFLite {
    override var modelFileName:String {
        get {"keras_resnet50_with_metadata"}
    }
}
