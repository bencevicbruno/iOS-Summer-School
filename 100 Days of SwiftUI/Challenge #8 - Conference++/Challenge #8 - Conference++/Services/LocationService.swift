//
//  LocationService.swift
//  Challenge #8 - Conference++
//
//  Created by Bruno Benčević on 9/30/21.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    typealias LocationConsumer = (String, CLLocationCoordinate2D) -> Void
    
    private var manager = CLLocationManager()
    private var locationConsumers = [LocationConsumer]()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation(_ consumer: @escaping LocationConsumer) {
        locationConsumers.append(consumer)
        manager.startUpdatingLocation()
    }
    
    // MARK: CLLocationManager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            requestLocationName(location)
        }
    }
    
    func requestLocationName(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if error == nil {
                if let placemark = placemarks?.first {
                    self?.notifyConsumers(location: placemark.name ?? "Unknown location", coordinates: location.coordinate)
                }
            }
        }
    }
    
    func notifyConsumers(location: String, coordinates: CLLocationCoordinate2D) {
        locationConsumers.forEach { consumer in
            consumer(location, coordinates)
        }
        locationConsumers.removeAll()
        manager.stopUpdatingLocation()
    }
    
    func getLocationName(_ location: CLLocationCoordinate2D, onSuccess: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { placemarks, error in
            if error == nil {
                if let placemark = placemarks?.first {
                    onSuccess(placemark.name ?? "Unknown location")
                }
            }
        }
    }
}
