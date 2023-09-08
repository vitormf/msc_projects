//
//  ViewController.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 19/06/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var smartSwitchSwitch: UISwitch!
    @IBOutlet weak var saveReportsSwitch: UISwitch!
    @IBOutlet weak var ignoreChargerSwitch: UISwitch!
    @IBOutlet weak var chargerControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        smartSwitchSwitch.isOn = SmartSwitchWebhook.enabled
        saveReportsSwitch.isOn = ReportService.enabled
        ignoreChargerSwitch.isOn = PowerControl.ignoreCharger
        chargerControl.selectedSegmentIndex = SmartSwitchWebhook.charger - 1
    }

    @IBAction func smartSwitchChanged(_ sender: Any) {
        SmartSwitchWebhook.enabled = smartSwitchSwitch.isOn
        eblog?("smartSwitchChanged \(SmartSwitchWebhook.enabled)")
    }

    @IBAction func saveReportsChanged(_ sender: Any) {
        ReportService.enabled = saveReportsSwitch.isOn
        eblog?("saveReportsChanged \(ReportService.enabled)")
    }

    @IBAction func ignoreChargerChanged(_ sender: Any) {
        PowerControl.ignoreCharger = ignoreChargerSwitch.isOn
        eblog?("ignoreChargerChanged \(PowerControl.ignoreCharger)")
    }

    @IBAction func chargerChanged(_ sender: Any) {
        SmartSwitchWebhook.charger = chargerControl.selectedSegmentIndex + 1
        eblog?("chargerChanged \(SmartSwitchWebhook.charger)")
    }

}

