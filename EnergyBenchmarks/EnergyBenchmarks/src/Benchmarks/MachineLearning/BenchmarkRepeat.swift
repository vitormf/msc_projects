//
//  BenchmarkRepeat.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 23/10/2023.
//

import Foundation
import DeviceKit

enum BenchmarkRepeat:UInt64 {
    
    case mobileNetV2,resNet50,bert;
    
    // iPhone 8+
    private static let iphone8plus_mobileNetV2_tiny   = 140_000;
    private static let iphone8plus_mobileNetV2_large  = 100_000;
    private static let iphone8plus_resnet50_tiny      = 100_000;
    private static let iphone8plus_resnet50_large     = 50_000;
    private static let iphone8plus_bertQA             = 1_500;
    
    // iPhone 11 pro
    private static let iphone11pro_mobileNetV2_tiny   = 400_000;
    private static let iphone11pro_mobileNetV2_large  = 250_000;
    private static let iphone11pro_resnet50_tiny      = 130_000;
    private static let iphone11pro_resnet50_large     = 70_000;
    private static let iphone11pro_bertQA             = 5_000;
    
    // iPad Air 4
    private static let ipadair4_mobileNetV2_tiny      = 900_000;
    private static let ipadair4_mobileNetV2_large     = 700_000;
    private static let ipadair4_resnet50_tiny         = 600_000;
    private static let ipadair4_resnet50_large        = 250_000;
    private static let ipadair4_bertQA                = 20_000;
    
    
    var total:UInt64 { get { UInt64(calculate()) } }
    
    private func calculate() -> Int {
        switch(Device.current) {
        case .iPhone8Plus:
            return iPhone8plus()
        case .iPhone11Pro:
            return iphone11pro()
        case .iPadAir4:
            return ipadair4()
        default:
            return 0
        }
    }
    
    private func iPhone8plus() -> Int {
        switch(currentImageNetDataSet) {
        case .tinyImageNet:
            return iPhone8plus_tiny()
        case .largeImageNet:
            return iPhone8plus_large()
        }
    }
    
    private func iphone11pro() -> Int {
        switch(currentImageNetDataSet) {
        case .tinyImageNet:
            return iphone11pro_tiny()
        case .largeImageNet:
            return iphone11pro_large()
        }
    }
    
    private func ipadair4() -> Int {
        switch(currentImageNetDataSet) {
        case .tinyImageNet:
            return ipadair4_tiny()
        case .largeImageNet:
            return ipadair4_large()
        }
    }
    
    
    
    private func iPhone8plus_tiny() -> Int {
        switch(self) {
        case .mobileNetV2:
            return BenchmarkRepeat.iphone8plus_mobileNetV2_tiny;
        case .resNet50:
            return BenchmarkRepeat.iphone8plus_resnet50_tiny;
        case .bert:
            return BenchmarkRepeat.iphone8plus_bertQA;
        }
    }
    
    private func iPhone8plus_large() -> Int {
        switch(self) {
        case .mobileNetV2:
            return BenchmarkRepeat.iphone8plus_mobileNetV2_large;
        case .resNet50:
            return BenchmarkRepeat.iphone8plus_resnet50_large;
        case .bert:
            return BenchmarkRepeat.iphone8plus_bertQA;
        }
    }
    
    private func iphone11pro_tiny() -> Int {
        switch(self) {
        case .mobileNetV2:
            return BenchmarkRepeat.iphone11pro_mobileNetV2_tiny;
        case .resNet50:
            return BenchmarkRepeat.iphone11pro_resnet50_tiny;
        case .bert:
            return BenchmarkRepeat.iphone11pro_bertQA;
        }
    }
    
    private func iphone11pro_large() -> Int {
        switch(self) {
        case .mobileNetV2:
            return BenchmarkRepeat.iphone11pro_mobileNetV2_large;
        case .resNet50:
            return BenchmarkRepeat.iphone11pro_resnet50_large;
        case .bert:
            return BenchmarkRepeat.iphone11pro_bertQA;
        }
    }
    
    private func ipadair4_tiny() -> Int {
        switch(self) {
        case .mobileNetV2:
            return BenchmarkRepeat.ipadair4_mobileNetV2_tiny;
        case .resNet50:
            return BenchmarkRepeat.ipadair4_resnet50_tiny;
        case .bert:
            return BenchmarkRepeat.ipadair4_bertQA;
        }
    }
    
    private func ipadair4_large() -> Int {
        switch(self) {
        case .mobileNetV2:
            return BenchmarkRepeat.ipadair4_mobileNetV2_large;
        case .resNet50:
            return BenchmarkRepeat.ipadair4_resnet50_large;
        case .bert:
            return BenchmarkRepeat.ipadair4_bertQA;
        }
    }
    

}

