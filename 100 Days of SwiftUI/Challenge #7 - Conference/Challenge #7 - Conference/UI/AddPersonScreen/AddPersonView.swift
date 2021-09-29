//
//  AddPersonView.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import SwiftUI

struct AddPersonView: View {
    @State private var image: UIImage?
    @State private var firstName = ""
    @State private var lastName = ""
    
    var body: some View {
        Form {
            HStack(alignment: .center) {
                OptionalPersonImageView(image: image)
            }
            
            Section(header: Text("Info")) {
                TextField("First name", text: $firstName)
                
                TextField("Last name", text: $lastName)
            }
            
            Button {
                print("Trying to add a person!")
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
    }
    
    var canAddPerson: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView()
    }
}
