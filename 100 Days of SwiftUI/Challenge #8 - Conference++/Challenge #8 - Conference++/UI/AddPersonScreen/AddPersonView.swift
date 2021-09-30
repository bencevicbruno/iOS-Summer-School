//
//  AddPersonView.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import SwiftUI
import CoreLocation

struct AddPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var onAddPersonTapped: ((Person) -> Void)?
    
    @State private var image: UIImage?
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var conferenceLocationName = "Unknown location"
    @State private var conferenceLocationCoordinates = CLLocationCoordinate2D()
    
    @State private var showingImagePickerSheet = false
    
    let locationService = LocationService()
    
    var body: some View {
        Form {
            HStack(alignment: .center) {
                Spacer()
                
                OptionalPersonImageView(image: $image)
                    .frame(width: 200, height: 200)
                    .onTapGesture(perform: openImagePicker)
                
                Spacer()
            }
            
            Section(header: Text("Info")) {
                TextField("First name", text: $firstName)
                
                TextField("Last name", text: $lastName)
            }
            
            Section {
                VStack {
                    Text(conferenceLocationName)
                    
                    ZStack {
                        MapView(centerCoordinate: $conferenceLocationCoordinates) { newCoordinates in
                            locationService.getLocationName(newCoordinates) { newName in
                                DispatchQueue.main.async {
                                    self.conferenceLocationName = newName
                                }
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 10)
                        
                        Image(systemName: "plus")
                            .clipShape(Circle())
                        
                    }
                    .frame(width: 300, height: 300)
                }
            }
            
            Button {
                let person = Person(firstName: self.firstName, lastName: self.lastName, image: image ?? UIImage(systemName: "questionmark.circle")!)
                person.latitude = conferenceLocationCoordinates.latitude
                person.longitude = conferenceLocationCoordinates.longitude
                
                self.onAddPersonTapped?(person)
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Add")
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .padding(.horizontal)
                    .background(canAddPerson ? Color.blue : Color.gray)
                    .clipShape(Capsule(style: .circular))
            }
            .disabled(!canAddPerson)
        }
        .sheet(isPresented: $showingImagePickerSheet, content: {
            ImagePickerView() { pickedImage in
                self.image = pickedImage
            }
        })
        .onAppear(perform: updateToCurrentLocation)
    }
    
    var canAddPerson: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func openImagePicker() {
        self.showingImagePickerSheet = true
    }
    
    func updateToCurrentLocation() {
        locationService.requestLocation { (name, coordinates) in
            DispatchQueue.main.async {
                self.conferenceLocationName = name
                self.conferenceLocationCoordinates = coordinates
            }
        }
    }
    
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView()
    }
}
