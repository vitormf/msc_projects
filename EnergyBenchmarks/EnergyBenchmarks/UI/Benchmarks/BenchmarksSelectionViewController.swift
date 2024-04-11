//
//  BenchmarksSelectionViewController.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 14/07/21.
//

import UIKit


fileprivate let mobilenet = false
fileprivate let resnet = true
fileprivate let bert = false

fileprivate let pyTorch = true
fileprivate let onlyPytorch = true

fileprivate func filterBenchmarks() -> [Benchmark] {
    var benchmarks = [Benchmark]()
    if (mobilenet) { benchmarks.append(contentsOf: allMobileNetBenchmarks) }
    if (resnet) { benchmarks.append(contentsOf: allResNetBenchmarks) }
    if (bert) { benchmarks.append(contentsOf: allBertBenchmarks) }
    return benchmarks
        .filter { b in !(b is  PyTorchVisionBenchmark && !pyTorch) }
        .filter { b in !(!(b is  PyTorchVisionBenchmark) && onlyPytorch)  }
}
//let allBenchmarks:[Benchmark] = allArrayBenchmarks + allConcurrencyBenchmarks + allSleepBenchmarks + allMachineLearningBenchmarks + allThroughputBenchmarks
//let allBenchmarks:[Benchmark] = allMobileNetBenchmarks
let allBenchmarks:[Benchmark] = filterBenchmarks()

let isTestingPyTorch = allBenchmarks.contains { b in b is PyTorchVisionBenchmark }

class BenchmarksSelectionViewController: UIViewController {
    
    var availableBenchmarks:[Benchmark] = allBenchmarks
    var selectedBenchmarks:[Benchmark] = []
    
    @IBOutlet weak var availableTableView: UITableView!
    @IBOutlet weak var selectedTableView: UITableView!
    @IBOutlet weak var executionsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        selectedBenchmarks = allMachineLearningBenchmarks
        reloadData()
    }
    
    func textFor(_ benchmark:Benchmark) -> String {
        return "\(benchmark.category):\(benchmark.identifier)"
    }

    func reloadData() {
        availableBenchmarks.sort { b1, b2 in
            return textFor(b1) < textFor(b2)
        }
        selectedBenchmarks.sort { b1, b2 in
            return textFor(b1) < textFor(b2)
        }
        availableTableView.reloadData()
        selectedTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? BenchmarkExecutionViewController else { return }
        
        var benchmarks:[Benchmark] = []
        let repeats:Int = Int(self.executionsTextField.text ?? "0") ?? 0
        for _ in 1...repeats {
            benchmarks.append(contentsOf: selectedBenchmarks)
        }
        viewController.benchmarks = benchmarks
    }
}


extension BenchmarksSelectionViewController: UITableViewDataSource {
    
    func dataArray(_ tableView: UITableView) -> [Benchmark] {
        tableView == availableTableView ? availableBenchmarks : selectedBenchmarks
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray(tableView).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataArray = dataArray(tableView)
        let identifier = "benchmark"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
        
        cell.textLabel?.text = textFor(dataArray[indexPath.row])
        
        return cell
    }
}


extension BenchmarksSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == availableTableView {
            let benchmark = availableBenchmarks.remove(at: indexPath.row)
            selectedBenchmarks.append(benchmark)
        } else {
            let benchmark = selectedBenchmarks.remove(at: indexPath.row)
            availableBenchmarks.append(benchmark)
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        reloadData()
    }
    
}

extension BenchmarksSelectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
