//
//  ContentView.swift
//  Challenge #1 - UnitConvert
//
//  Created by Bruno Benčević on 9/17/21.
//

import SwiftUI

struct ContentView: View {
    @State private var amount = ""
    @State private var startUnit = 0
    @State private var endUnit = 0
    
    private var units = ["C", "K", "F"]
    
    private var convertedUnit: Double {
        guard let unitAmount = Double(amount) else { return 0 }
        
        let unitInCelsius = startUnit == 1 ? (unitAmount - 273.15) : startUnit == 2 ? (unitAmount - 32)/1.8 : unitAmount
        
        return endUnit == 1 ? (unitInCelsius + 273.15) : endUnit == 2 ? (unitInCelsius * 1.8 + 32) : unitInCelsius
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Insert amount", text: $amount)
                
                Section(header: Text("Select your unit")) {
                    Picker("", selection: $startUnit) {
                        ForEach(0..<units.count) { index in
                            Text("\(units[index])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Convert to unit")) {
                    Picker("", selection: $endUnit) {
                        ForEach(0..<units.count) { index in
                            Text("\(units[index])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Text("Converted unit: \(convertedUnit)")
            }
            
            .navigationBarTitle("UnitConvert")
            .foregroundColor(.blue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
