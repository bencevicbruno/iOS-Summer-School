//
//  ViewController.swift
//  Project #22
//
//  Created by Bruno Benčević on 8/19/21.
//

import CoreLocation
import UIKit

class ViewController: UIViewController {

    @IBOutlet var beaconName: UILabel!
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var proximityCircle: UIView!
    
    var beaconAlreadyRanged = false
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        self.view.backgroundColor = .gray
        proximityCircle.layer.cornerRadius = 150
    }
}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScaning()
                }
            }
        }
    }
    
    func startScaning() {
        let beaconUUID = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: beaconUUID, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if !beaconAlreadyRanged {
                beaconAlreadyRanged.toggle()
                notifyUser()
            }
            update(distance: beacon.proximity, name: beacon.uuid.uuidString)
        } else {
            update(distance: .unknown)
        }
    }
    
    func notifyUser() {
        let alert = UIAlertController(title: "Beacon found!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func update(distance: CLProximity, name: String = "No beacon found!") {
        beaconName.text = name
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.proximityCircle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.proximityCircle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case.immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.proximityCircle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.proximityCircle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
}
