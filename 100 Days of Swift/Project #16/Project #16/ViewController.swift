//
//  ViewController.swift
//  Project #16
//
//  Created by Bruno Benčević on 8/13/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addAnnotations()
        
    }
    
    func setupNavigationBar() {
        self.title = "Capitals"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(chooseMapType))
    }
    
    // MARK: Setup
    
    @objc func chooseMapType() {
        let mapTypes = ["Hybrid": MKMapType.hybrid, "Hybrid - flyover": MKMapType.hybridFlyover, "Satelite": MKMapType.satellite, "Standard": MKMapType.standard, "Satelite - flyover": MKMapType.satelliteFlyover, "Standard - muted": MKMapType.mutedStandard].sorted { $0.key > $1.key }
        
        let alert = UIAlertController(title: "Choose a map type", message: nil, preferredStyle: .alert)
        
        mapTypes.forEach {
            typeName, type in
            alert.addAction(UIAlertAction(title: typeName, style: .default) {
                [weak self] _ in
                self?.mapView.mapType = type
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func addAnnotations() {
        let london = Capital(title: "London", coord: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coord: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago")
        let paris = Capital(title: "Paris", coord: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of light")
        let rome = Capital(title: "Rome", coord: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington", coord: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036661), info: "Named after George himself")
        
        mapView.addAnnotations([
            london, oslo, paris, rome, washington
        ])
    }
    
    // MARK: MapView
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let IDENTIFIER = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: IDENTIFIER)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: IDENTIFIER)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        if let pin = annotationView as? MKPinAnnotationView {
            pin.pinTintColor = UIColor.blue
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let alert = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Wiki page", style: .default) {
            [weak self] this in
            if let viewController = self?.storyboard?.instantiateViewController(identifier: "WikipediaViewController") as? WikipediaViewController {
                
                viewController.city = placeName
                self?.navigationController?.pushViewController(viewController, animated: true);
            }
        })
        alert.addAction(UIAlertAction(title: "Go back", style: .default))
        
        self.present(alert, animated: true)
    }
}
