//
//  ResultsSelectionViewController.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 14/07/21.
//

import UIKit
import FirebaseDatabase


class ResultsSelectionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    enum ResultSelectionSteps {
        case category, identifier, model, results
    }
    
    var currentStep = ResultSelectionSteps.category
    var data = [String]()
    var ref:DatabaseReference!
    
    var category:String = ""
    var identifier:String = ""
    var model:String = ""
    var results:[BenchmarkResult] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.ref = ReportService.results()
            self?.reloadData()
        }
    }
    
    func reloadData() {
        ref.getData { [weak self] error, snapshot in
            guard let value = snapshot?.value as? [String:Any] else { return }
            self?.reloadTableView(Array(value.keys).sorted())
        }
    }
    
    func reloadTableView(_ data:[String]) {
        self.data = data
        DispatchQueue.main.async {
            self.tableView.isUserInteractionEnabled = true
            self.tableView.reloadData()
        }
    }
    
    func select(index:Int) {
        var nextStep:ResultSelectionSteps
        switch currentStep {
        case .category:
            nextStep = .identifier
            category = data[index]
        case .identifier:
            nextStep = .model
            identifier = data[index]
        case .model:
            nextStep = .results
            model = data[index]
        case .results:
            nextStep = .category
        }
        
        showDataFor(step: nextStep)
    }
    
    
    func showDataFor(step:ResultSelectionSteps) {
        currentStep = step
        switch step {
        case .category:
            category = ""
            identifier = ""
            model = ""
            results = []
            ref = ReportService.results()
            reloadData()
            titleLabel.text = "Select Category"
            
        case .identifier:
            ref = ref.child(category)
            reloadData()
            titleLabel.text = "Select Identifier"
            
        case .model:
            ref = ref.child(identifier)
            reloadData()
            titleLabel.text = "Select Model"
            
        case .results:
            ref = ref.child(model)
            openResults()
        }
    }
    
    func openResults() {
        ref.getData { [weak self] error, snapshot in
            guard let self = self else { return }
            
            if let snapValue = snapshot?.value as? NSDictionary,
               let resultValues = snapValue.allValues as? [NSDictionary] {
                let results = resultValues.map { rvalue in ReportService.result(value: rvalue) }
                self.results = results
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showResults", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultsVC = segue.destination as! ResultsViewController
        resultsVC.category = self.category
        resultsVC.identifier = self.identifier
        resultsVC.model = self.model
        resultsVC.results = self.results
        self.showDataFor(step: .category)
    }
    
}


extension ResultsSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "result_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

extension ResultsSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isUserInteractionEnabled = false
        select(index:indexPath.row)
    }
    
}
