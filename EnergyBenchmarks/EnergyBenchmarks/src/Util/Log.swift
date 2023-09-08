//
//  Log.swift
//  EnergyBenchmarksTests
//
//  Created by Vitor on 22/06/21.
//

import UIKit


enum LogLevel: Int {
    case Info, Debug, None
}

let logLevel = LogLevel.Info

var logTextView:UITextView? = nil

typealias EbLog = (_ message:String)->()

private func _eblog(level:LogLevel = .Debug, _ message:String) {
    if level.rawValue >= logLevel.rawValue {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH'h'mm'm'ss's'"
        let now = formatter.string(from: Date())
        let text = "EBLOG[\(now)]: \(message)"
        print(text)
        printToTextView(text)
    }
}


private func printToTextView(_ text:String) {
    guard  let textView = logTextView else { return }
    
    DispatchQueue.main.async {
        textView.insertText("\n\(text)")
        if textView.text.count > 0 {
            let location = textView.text.count - 1
            let bottom = NSMakeRange(location, 1)
            textView.scrollRangeToVisible(bottom)
        }
    }
}

var eblog:EbLog? = { message in
    _eblog(message)
}

var eblogInfo:EbLog? = { message in
    _eblog(level: .Info, message)
}

