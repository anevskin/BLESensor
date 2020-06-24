//
//  DeviceAccelerometerDataSource.swift
//  BLESensor
//
//  Created by Nikola Anevski on 5/30/20.
//  Copyright © 2020 Nikola Anevski. All rights reserved.
//

import Foundation
import CoreMotion

class DeviceAccelerometerDataSource: AccelerometerDataSource {
    
    var onUpdate: ((AccelerometerData) -> Void)?
    
    var manager = CMMotionManager()
    
    func start() {
        guard manager.isAccelerometerAvailable else {
            print("Accelerometer Not Available")
            return
        }
        
        if manager.isAccelerometerActive {return}
        
        manager.accelerometerUpdateInterval = 1.0
        manager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
            if let error = error {
                print("error accelerometer update: \(error.localizedDescription)")
            }else if let data = data{
                print("acceleromter data: \(data)")
                let accelerometerData = AccelerometerData(timestamp: data.timestamp, x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z)
                self?.onUpdate?(accelerometerData)
            }
        }
    }
    
    func stop() {
        manager.stopAccelerometerUpdates()
    }
    
    
}
