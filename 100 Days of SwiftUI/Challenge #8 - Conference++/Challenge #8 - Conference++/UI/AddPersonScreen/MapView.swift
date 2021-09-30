//
//  MapView.swift
//  Challenge #8 - Conference++
//
//  Created by Bruno Benčević on 9/30/21.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var onLocationChange: ((CLLocationCoordinate2D) -> Void)?
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        if centerCoordinate.latitude != uiView.centerCoordinate.latitude
            && centerCoordinate.longitude != uiView.centerCoordinate.longitude {
            
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegion(center: centerCoordinate,
                                                      latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
            uiView.setRegion(coordinateRegion, animated: true)
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
            parent.onLocationChange?(parent.centerCoordinate)
        }
    }
}
