//
//  ResultsViewController.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 14/07/21.
//

import UIKit

class ResultsViewController: UIViewController {
    
    
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var mean: UILabel!
    @IBOutlet weak var standardDeviation: UILabel!
    @IBOutlet weak var median: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var meanBattery: UILabel!
    @IBOutlet weak var sdBattery: UILabel!
    @IBOutlet weak var medianBattery: UILabel!
    @IBOutlet weak var meanDuration: UILabel!
    @IBOutlet weak var sdDuration: UILabel!
    @IBOutlet weak var medianDuration: UILabel!
    
    var category:String = ""
    var identifier:String = ""
    var model:String = ""
    var results:[BenchmarkResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let batteryResults = results.map { result in  Float(result.battery) }
        let batteryMean = batteryResults.avg()
        let batterySD = batteryResults.std()
        let batteryMedian = batteryResults.median()
        
        let durationResults = results.map { result in  result.duration }
        let durationMean = durationResults.avg()
        let durationSD = durationResults.std()
        let durationMedian = durationResults.median()
        
        self.info.text = "\(category) / \(identifier) / \(model)"
        self.count.text = "Count: \(results.count)"
        
        self.meanBattery.text = batteryResult(batteryMean)
        self.sdBattery.text = batteryResult(batterySD)
        self.medianBattery.text = batteryResult(batteryMedian)
        
        self.meanDuration.text = durationResult(durationMean)
        self.sdDuration.text = durationResult(durationSD)
        self.medianDuration.text = durationResult(durationMedian)

    }
    
    private func batteryResult(_ value:Float) -> String {
        return "\(Int(value.isNaN ? 0.0 : value))"
    }
    
    private func durationResult(_ value:TimeInterval) -> String {
        let value = value.isNaN ? 0.0 : value
        let hours = Int(value)/3600
        let mins = (Int(value)/60)%60
        let secs = Int(value)%60
//        let microsecs = Int(value*1_000_000) % 1_000_000
        var result = ""
        if (hours > 0) {
            result += "\(hours)h "
        }
        if (mins > 0) {
            result += "\(mins)m "
        }
        if secs > 0 {
            result += "\(secs)s "
        }
//        if mins == 0 {
//            result += "\(microsecs)µs"
//        }
        return result
    }
    
}

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "results"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
        
        let result = results[indexPath.row]
        
        cell.textLabel?.text = "Battery \(result.battery) - Duration \(durationResult(result.duration))"
        
        return cell
    }
    
    
}

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
