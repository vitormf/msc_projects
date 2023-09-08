//
//  AppDelegate.swift
//  EnergyBenchmarks
//
//  Created by Vitor on 19/06/21.
//

import UIKit
import DeviceKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIScreen.main.brightness = 0
        setupInitialState()
        ReportService.setup()
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+10) {
//            fatalError("Crash was triggered")
//        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    func setupInitialState() {
#if targetEnvironment(simulator)
        let isSimulator = true
#else
        let isSimulator = false
#endif

        SmartSwitchWebhook.enabled = !isSimulator
        ReportService.enabled = !isSimulator
        PowerControl.ignoreCharger = isSimulator
        switch(Device.current) {
        case .iPhone8Plus:
            SmartSwitchWebhook.charger = 2
        default:
            SmartSwitchWebhook.charger = 1
        }
    }
}

