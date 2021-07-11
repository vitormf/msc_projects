//
//  SmartSwitchWebhook.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 20/06/21.
//

import UIKit

class SmartSwitchWebhook {
    enum WebHookCommand : String {
        case battery_benchmark_setup,
             battery_benchmark_start;
    }
    
    let webhookTemplate = "https://maker.ifttt.com/trigger/%@/with/key/c7SjqnOZxdhsSwxIKTvCGX"
    
    // sends command to start or
    func callWebhook(command:WebHookCommand) {
        query(address: String(format: webhookTemplate, command.rawValue))
    }
    
    //synchronous request
    @discardableResult
    func query(address: String) -> String {
        let url = URL(string: address)
        let semaphore = DispatchSemaphore(value: 0)
        
        var result: String = ""
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            result = String(data: data!, encoding: String.Encoding.utf8)!
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        return result
    }
    
    func startCharging() {
        callWebhook(command: .battery_benchmark_setup)
    }
    
    func stopCharging() {
        callWebhook(command: .battery_benchmark_start)
    }
}
