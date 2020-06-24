//
//  BLERoleSelectViewController.swift
//  BLESensor
//
//  Created by Nikola Anevski on 5/30/20.
//  Copyright © 2020 Nikola Anevski. All rights reserved.
//

import UIKit

enum BLERole {
    case central
    case peripheral
}

class BLERoleSelectViewController: UIViewController {

    var onChoice: ((BLERole) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func selectCentral(_ sender: Any) {
        onChoice?(.central)
    }
    
    @IBAction func selectPeripheral(_ sender: Any) {
        onChoice?(.peripheral)
    }
    
}
