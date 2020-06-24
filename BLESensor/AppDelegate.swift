//
//  AppDelegate.swift
//  BLESensor
//
//  Created by Nikola Anevski on 5/23/20.
//  Copyright © 2020 Nikola Anevski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var flowController: AppFLowController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        flowController = AppFLowController(window: window!)
        flowController?.start()
        
        return true
    }


}

