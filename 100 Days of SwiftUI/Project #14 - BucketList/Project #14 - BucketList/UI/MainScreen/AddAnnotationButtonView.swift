//
//  AddMarkerButtonView.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import SwiftUI
import CoreLocation

struct AddAnnotationButtonView: View {
    @Binding var location: CLLocationCoordinate2D
    var onTapped: ((CodableMKPointAnnotation) -> Void)?
    
    var body: some View {
        Button(action: {
            let newLocation = CodableMKPointAnnotation()
            newLocation.coordinate = self.location
            newLocation.title = "Example Location"
            
            self.onTapped?(newLocation)
        }) {
            Image(systemName: "plus")
        }
        .padding()
        .background(Color.black.opacity(0.75))
        .foregroundColor(.white)
        .font(.title)
        .clipShape(Circle())
        .padding(.trailing)
    }
}

struct AddAnnotationButtonView_Previews: PreviewProvider {
    static var previews: some View {
        var location = CLLocationCoordinate2D()
        
        let locationBinding = Binding<CLLocationCoordinate2D>(
            get: {
                location
            }, set: {
                location = $0
            }
        )
        AddAnnotationButtonView(location: locationBinding)
    }
}
