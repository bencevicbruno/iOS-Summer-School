//
//  ContentView.swift
//  Project #4 - BetterRest
//
//  Created by Bruno Benčević on 9/20/21.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    static private var idealBedtimeText = "Your ideal bedtime is"
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?").font(.headline)) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .onChange(of: wakeUp, perform: { _ in
                            calculateBedtime()
                        })
                }
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                    Text("\(sleepAmount, specifier: "%g") hours")
                }
                .onChange(of: sleepAmount, perform: { _ in
                    calculateBedtime()
                })
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(value: $coffeeAmount, in: 1...20) {
                    Text(coffeeAmount == 1 ? "1 Cup" : "\(coffeeAmount) Cups")
                }
                .onChange(of: coffeeAmount, perform: { _ in
                    calculateBedtime()
                })
                
                Spacer()
                
                Text(ContentView.idealBedtimeText)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .navigationBarTitle("BetterRest")
//            .navigationBarItems(trailing: Button("Calculate", action: calculateBedtime).foregroundColor(.purple))
//            .alert(isPresented: $showingAlert, content: {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            })
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            ContentView.idealBedtimeText = "Your ideal bedtime is \(formatter.string(from: sleepTime))"
        } catch {
            ContentView.idealBedtimeText = "Error calculating your bedtime"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
