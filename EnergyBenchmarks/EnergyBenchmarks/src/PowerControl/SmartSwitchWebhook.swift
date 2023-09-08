//
//  SmartSwitchWebhook.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 20/06/21.
//

import UIKit

class SmartSwitchWebhook {

    static var enabled = true
    static var charger = 1

    enum WebHookCommand : String {
        case charger_stop,
             charger_start;
    }
    
    let webhookTemplate = "https://maker.ifttt.com/trigger/%@%@/with/key/c7SjqnOZxdhsSwxIKTvCGX"
    
    // sends command to start or
    func callWebhook(command:WebHookCommand) {
        let chargerSuffix = SmartSwitchWebhook.charger == 1 ? "" : "\(SmartSwitchWebhook.charger)"
        let address = String(format: webhookTemplate, command.rawValue, chargerSuffix)
        query(address: address)
    }
    
    //synchronous request
    @discardableResult
    func query(address: String) -> String {
        if !SmartSwitchWebhook.enabled {
            return ""
        }
        eblog?(address)
        let url = URL(string: address)
        let semaphore = DispatchSemaphore(value: 0)
        
        var result: String = ""
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if (data == nil) {
                eblog?("nil response from webhook")
            } else {
                result = String(data: data!, encoding: String.Encoding.utf8)!
                eblog?(result)
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        return result
    }
    
    func startCharging() {
        callWebhook(command: .charger_start)
    }
    
    func stopCharging() {
        callWebhook(command: .charger_stop)
    }
}
