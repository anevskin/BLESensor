//
//  DiscoveredPeripheral.swift
//  BLESensor
//
//  Created by Nikola Anevski on 5/30/20.
//  Copyright © 2020 Nikola Anevski. All rights reserved.
//

import Foundation
import CoreBluetooth

class DiscoveredPeripheral {
    
    var peripheral: CBPeripheral
    var rssi: NSNumber
    var advertesmentData: [String: Any]
    
    init(peripheral: CBPeripheral, rssi: NSNumber, advertesmentData:[String: Any]) {
        self.peripheral = peripheral
        self.rssi = rssi
        self.advertesmentData = advertesmentData
    }
}
