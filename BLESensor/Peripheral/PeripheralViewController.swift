//
//  PeripheralViewController.swift
//  BLESensor
//
//  Created by Nikola Anevski on 5/30/20.
//  Copyright © 2020 Nikola Anevski. All rights reserved.
//

import UIKit

class PeripheralViewController: UIViewController {
    
    var peripheral: BLEPeripheral!

    override func viewDidLoad() {
        super.viewDidLoad()

        peripheral = BLEPeripheral(dataSource: DeviceAccelerometerDataSource())
    }
    


}
