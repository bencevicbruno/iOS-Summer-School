//
//  ContentView.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct MainView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    @State private var isUnlocked = false
    
    var body: some View {
        ZStack  {
            if self.isUnlocked {
                MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                    .edgesIgnoringSafeArea(.all)
                
                LocationMarkerView()
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddAnnotationButtonView(location: self.$centerCoordinate) { location in
                            self.locations.append(location)
                            self.selectedPlace = location
                            self.showingEditScreen = true
                        }
                    }
                }
            } else {
                UnlockButtonView(text: "Unlock Places") {
                    self.authenticate()
                }
            }
        }
        .alert(isPresented: $showingPlaceDetails) {
            Alert(title: Text(selectedPlace?.title ?? "Unknown"),
                  message: Text(selectedPlace?.subtitle ?? "Missing place information."),
                  primaryButton: .default(Text("OK")),
                  secondaryButton: .default(Text("Edit")) {
                    self.showingEditScreen = true
                  })
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if self.selectedPlace != nil {
                EditAnnotationView(annotation: self.selectedPlace!)
            }
        }
        .onAppear(perform: loadData)
    }
}

extension MainView {
    func authenticate() {
        let authService = AuthenticationService()
        
        authService.authenticate {
            self.isUnlocked = true
        } onFail: { errorMessage in
            print(errorMessage)
        }
    }
    
    func loadData() {
        let dataService = AppDataService()
        
        dataService.loadData { loadedLocations in
            DispatchQueue.main.async {
                self.locations = loadedLocations
            }
        } onFail: { errorMessage in
            print("Loading data failed: \(errorMessage)")
        }
    }
    
    func saveData() {
        let dataService = AppDataService()
        
        dataService.saveData(self.locations) {
            print("Data saved!")
        } onFail: { errorMessage in
            print("Saving data failed: \(errorMessage)")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
