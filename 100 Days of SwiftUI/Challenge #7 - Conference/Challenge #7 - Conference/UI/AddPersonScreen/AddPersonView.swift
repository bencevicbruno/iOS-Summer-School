//
//  AddPersonView.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import SwiftUI

struct AddPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var onAddPersonTapped: ((Person) -> Void)?
    
    @State private var image: UIImage?
    @State private var firstName = ""
    @State private var lastName = ""
    
    @State private var showingImagePickerSheet = false
    
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
            
            Button {
                let person = Person(firstName: self.firstName, lastName: self.lastName, image: image ?? UIImage(systemName: "questionmark.circle")!)
                
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
    }
    
    var canAddPerson: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func openImagePicker() {
        self.showingImagePickerSheet = true
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView()
    }
}
