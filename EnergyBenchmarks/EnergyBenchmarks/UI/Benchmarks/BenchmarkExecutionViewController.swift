//
//  BenchmarkExecutionViewController.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 14/07/21.
//

import UIKit


class BenchmarkExecutionViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    var benchmarks:[Benchmark]? = nil
    var suite:BenchmarkExecutionSuite?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logTextView = textView
        self.closeButton.isEnabled = false
        self.textView.font = self.textView.font?.monospacedDigitFont
        execute()
    }

    deinit {
        logTextView = nil
    }
    
    func execute() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            guard let benchmarks = self.benchmarks else {
                self.textView.text = "Empty Benchmarks List"
                return
            }
            self.suite = BenchmarkExecutionSuite(benchmarks: benchmarks)
            self.suite?.execute(progress: { completed, current, total, result in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.closeButton.isEnabled = completed
                    let progress = Float(current)/Float(total)
                    self.progressView.progress = progress
                    self.progressLabel.text = "\(Int(progress * 100))%"
                }
            })

        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = textView.text
    }
}

extension UIFont {
    var monospacedDigitFont: UIFont {
        let newFontDescriptor = fontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: newFontDescriptor, size: 0)
    }
}

private extension UIFontDescriptor {
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [[UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                                              UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector]]
        let fontDescriptorAttributes = [UIFontDescriptor.AttributeName.featureSettings: fontDescriptorFeatureSettings]
        let fontDescriptor = self.addingAttributes(fontDescriptorAttributes)
        return fontDescriptor
    }
}
