//
//  ReportService.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 14/07/21.
//

import Foundation
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth

class ReportService {
    
    static var enabled = true
    private static let instance = ReportService()

    private let db = Database.database().reference()

    static func setup() {
        FirebaseApp.configure()
        signIn()
    }
    
    private static func signIn() {
        let auth = Auth.auth()
        if auth.currentUser == nil {
            auth.signInAnonymously()
        }
    }
    
    static func report(result:BenchmarkResult) {
        if !enabled {
            return
        }
        instance.db
            .child("BatteryUsageBenchmarks")
            .child(sanitize(result.category))
            .child(sanitize(result.identifier))
            .child(sanitize(result.model))
            .child(sanitize(String(result.timestamp)))
            .setValue([
                "timestamp": result.timestamp,
                "category": result.category,
                "identifier": result.identifier,
                "info": result.info,
                "battery": result.battery,
                "duration": result.duration,
                "os": result.os,
                "osVersion": result.osVersion,
                "model": result.model,
                "name": result.name,
                "cores": result.cores,
            ] as [String : Any])
        
    }
    
    static func sanitize(_ string:String) -> String {
        return string
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "#", with: "_")
            .replacingOccurrences(of: "$", with: "_")
            .replacingOccurrences(of: "[", with: "(")
            .replacingOccurrences(of: "]", with: ")")
    }
    
    static func result(value:NSDictionary) -> BenchmarkResult {
        return BenchmarkResult(
            timestamp: value["timestamp"] as? UInt64 ?? 0,
            category: value["category"] as? String ?? "",
            identifier: value["identifier"] as? String ?? "",
            info: value["info"] as? String ?? "",
            battery: value["battery"] as? UInt ?? 0,
            duration: value["duration"] as? TimeInterval ?? 0.0,
            os: value["os"] as? String ?? "",
            osVersion: value["osVersion"] as? String ?? "",
            model: value["model"] as? String ?? "",
            name: value["name"] as? String ?? "",
            cores: value["cores"] as? Int ?? 0)
    }
    
    static func results() -> DatabaseReference {
        return instance.db.child("BatteryUsageBenchmarks")
    }
    
}
