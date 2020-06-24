//
//  BLECentral.swift
//  BLESensor
//
//  Created by Nikola Anevski on 5/30/20.
//  Copyright © 2020 Nikola Anevski. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLECentral: NSObject {
    
    private var manager: CBCentralManager!
    private(set) var discoveredPeripherals = [DiscoveredPeripheral]()
    var connectedPeripheral: CBPeripheral?
    
    var onDiscovered: (() -> Void)?
    var onDataUpdate: ((AccelerometerData) -> Void)?
    var onConnected: (() -> Void)?
    
    private var decoder = JSONDecoder()
    
    override init() {
        super.init()
        
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scanForPeripherals(){
        let options: [String : Any] = [CBCentralManagerScanOptionAllowDuplicatesKey: false]
        
        let lastPeripherals = manager.retrieveConnectedPeripherals(withServices: [CBUUID(string: BLEIdentifiers.serviceIdentifier)])
        if lastPeripherals.count > 0 {
            if let device = lastPeripherals.last {
                connectedPeripheral = device
                if let connected = connectedPeripheral {
                    manager.connect(connected, options: nil)
                }
            }
        }else{
            manager.scanForPeripherals(withServices: [CBUUID(string: BLEIdentifiers.serviceIdentifier)], options: options)
        }
    }
    
    func connect(at index:Int){
        guard index >= 0, index < discoveredPeripherals.count else {return}
        
        manager.stopScan()
        manager.connect(discoveredPeripherals[index].peripheral, options:nil)
    }
}


// MARK: - CBCentralManagerDelegate
extension BLECentral: CBCentralManagerDelegate, CBPeripheralDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            scanForPeripherals()
        }else{
            print("Off")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let existingPeripheral = discoveredPeripherals.first(where: {$0.peripheral == peripheral}){
            existingPeripheral.advertesmentData = advertisementData
            existingPeripheral.rssi = RSSI
        }else{
            discoveredPeripherals.append(DiscoveredPeripheral(peripheral: peripheral, rssi: RSSI, advertesmentData: advertisementData))
        }
        
        onDiscovered?()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        connectedPeripheral?.delegate = self
        connectedPeripheral?.discoverServices([CBUUID(string: BLEIdentifiers.serviceIdentifier)])
        onConnected?()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            // Handle disconection error
        }else{
            print("nothing to see here")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        central.connect(peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("discover services error: \(error.localizedDescription)")
        }else{
            peripheral.services?.forEach({ (service) in
                print("service discovered: \(service)")
                peripheral.discoverCharacteristics([CBUUID(string: BLEIdentifiers.characteristicIdentifier)], for: service)
            })
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("char. error: \(error.localizedDescription)")
        }else{
            service.characteristics?.forEach({ (characteristic) in
                print("characteristic discovered: \(characteristic)")
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }else if characteristic.properties.contains(.read){
                    peripheral.readValue(for: characteristic)
                }
                peripheral.discoverDescriptors(for: characteristic)
            })
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("didDiscoverDescriptorsFor: \(error.localizedDescription)")
        }else{
            characteristic.descriptors?.forEach({ (descriptor) in
                print("descriptor discovered: \(descriptor)")
                peripheral.readValue(for: descriptor)
            })
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("didUpdateValueFor characteristic: \(error.localizedDescription)")
        }else{
            print("characteristic value updated: \(characteristic)")
            if let value = characteristic.value {
                if let acceleromterData = try? decoder.decode(AccelerometerData.self, from: value) {
                    print(acceleromterData)
                    onDataUpdate?(acceleromterData)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        if let error = error {
            print("didUpdateValueFor descriptor: \(error.localizedDescription)")
        }else{
            print("descriptor value updated: \(descriptor)")
        }
    }
    
}
