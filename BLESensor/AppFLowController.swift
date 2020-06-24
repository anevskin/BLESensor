//
//  AppFLowController.swift
//  BLESensor
//
//  Created by Nikola Anevski on 5/30/20.
//  Copyright © 2020 Nikola Anevski. All rights reserved.
//

import UIKit

class AppFLowController {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BLERoleSelectViewController") as! BLERoleSelectViewController
        viewController.onChoice = { [weak self] (choice) in
            var nextViewController = UIViewController()
            switch choice {
            case .central:
                let viewController = DiscoveryViewController()
                viewController.onConnected = {
                    let accelerometerViewController = AccelerometerViewController()
                    accelerometerViewController.central = viewController.central
                    self?.window.rootViewController = accelerometerViewController
                }
                nextViewController = viewController
            case .peripheral:
                nextViewController = PeripheralViewController()
            }
            self?.window.rootViewController = nextViewController
        }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
