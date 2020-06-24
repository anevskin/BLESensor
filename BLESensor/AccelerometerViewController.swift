//
//  AccelerometerViewController.swift
//  BLESensor
//
//  Created by Nikola Anevski on 5/30/20.
//  Copyright © 2020 Nikola Anevski. All rights reserved.
//

import UIKit

class AccelerometerViewController: UIViewController {
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    var central: BLECentral?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        central?.onDataUpdate = { [weak self] data in
            DispatchQueue.main.async {
                self?.update(data)
            }
        }
    }


    func update(_ data: AccelerometerData){
        xLabel.text = String(format: "%.02f", data.x)
        yLabel.text = String(format: "%.02f", data.y)
        zLabel.text = String(format: "%.02f", data.z)
        
        let date = Date(timeIntervalSinceReferenceDate: data.timestamp)
        timestampLabel.text = date.debugDescription
    }

}
