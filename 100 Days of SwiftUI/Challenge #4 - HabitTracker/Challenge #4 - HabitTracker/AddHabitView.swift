//
//  AddHabitView.swift
//  Challenge #4 - HabitTracker
//
//  Created by Bruno Benčević on 9/23/21.
//

import SwiftUI

struct AddHabitView: View {
    let Background = LinearGradient(gradient: Gradient(colors: [Color(red: 0.8, green: 0.8, blue: 1.0), .white, .white]), startPoint: .bottom, endPoint: .top)
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habits: Habits
    
    @State private var name = ""
    @State private var description = ""
    @State private var sfImageName = ""
    
    @State private var isShowingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Background
                
                VStack(alignment: .leading) {
                    Text("Add new Habit")
                        .foregroundColor(.purple)
                        .fontWeight(.bold)
                        .font(Font.system(size: 30))
                    
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Description (optional)", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("SF Image Name (optional)", text: $sfImageName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom)
                    
                    HStack {
                        Button("Done") {
                            let habit = Habit(name: name, description: description.isEmpty ? nil : description, sfImageName: sfImageName.isEmpty ? nil : sfImageName, hours: 0.0)
                            
                            if name.isEmpty {
                                showAlert("Error creating Habit!", "You must provied a name for your new Habit.")
                            } else {
                                self.habits.items.append(habit)
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 100, height: 50)
                        .background(Color(red: 0.8, green: 0.8, blue: 1.0))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                        
                        Button("Cancel") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 100, height: 50)
                        .background(Color(red: 1.0, green: 0.8, blue: 0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                    }
                    
                    Spacer()
                }
                .padding()
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    
    func showAlert(_ title: String, _ message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.isShowingAlert = true
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(habits: Habits())
    }
}
