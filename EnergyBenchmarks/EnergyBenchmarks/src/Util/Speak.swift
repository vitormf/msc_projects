//
//  Speak.swift
//  EnergyBenchmarks
//
//  Created by Vitor Maciel on 21/02/23.
//

import Foundation
import AVFoundation

typealias EbSpeak = (_ text:String)->()


let synthesizer = AVSpeechSynthesizer()

var ebspeak:EbSpeak = { text in
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
    synthesizer.speak(utterance)
}

