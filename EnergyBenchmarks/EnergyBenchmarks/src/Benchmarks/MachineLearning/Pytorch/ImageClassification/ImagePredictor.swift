import UIKit

class ImagePredictor: Predictor {
    private var isRunning: Bool = false
    private var module: VisionTorchModule
    private var labels: [String]
    
    init(moduleFile:String) {
        if let filePath = Bundle.main.path(forResource: moduleFile, ofType: "pt"),
            let module = VisionTorchModule(fileAtPath: filePath) {
            self.module = module
        } else {
            fatalError("Failed to load model!")
        }
        if let filePath = Bundle.main.path(forResource: "words", ofType: "txt"),
            let labels = try? String(contentsOfFile: filePath) {
            self.labels = labels.components(separatedBy: .newlines)
        } else {
            fatalError("Label file was not found.")
        }
    }
    

    func predict(_ buffer: [Float32], resultCount: Int) throws -> ([InferenceResult], Double)? {
        if isRunning {
            return nil
        }
        isRunning = true
        let startTime = CACurrentMediaTime()
        var tensorBuffer = buffer;
        guard let outputs = module.predict(image: UnsafeMutableRawPointer(&tensorBuffer)) else {
            throw PredictorError.invalidInputTensor
        }
        isRunning = false
        let inferenceTime = (CACurrentMediaTime() - startTime) * 1000
        let results = topK(scores: outputs, labels: labels, count: resultCount)
        return (results, inferenceTime)
    }
}
