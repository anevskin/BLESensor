//
//  AccelerometerDataSource.swift
//  BLESensor
//
//  Created by Nikola Anevski on 5/30/20.
//  Copyright © 2020 Nikola Anevski. All rights reserved.
//

import Foundation

struct AccelerometerData: Codable {
    let timestamp: TimeInterval
    let x: Double
    let y: Double
    let z: Double
}

protocol AccelerometerDataSource {
    var onUpdate: ((AccelerometerData) -> Void)? {get set}
    
    func start()
    func stop()
}
