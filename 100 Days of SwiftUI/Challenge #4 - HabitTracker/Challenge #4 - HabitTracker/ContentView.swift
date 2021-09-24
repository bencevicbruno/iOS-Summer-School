//
//  ContentView.swift
//  Challenge #4 - HabitTracker
//
//  Created by Bruno Benčević on 9/23/21.
//

import SwiftUI

struct ContentView: View {
    let Background = LinearGradient(gradient: Gradient(colors: [Color(red: 0.8, green: 1.0, blue: 0.8), .white, .white]), startPoint: .bottom, endPoint: .top)
    
    @ObservedObject var habits = Habits()
    @State private var showingAddHabitSheet = false
    
    init() {
        UITableView.appearance().backgroundColor = .none
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Background
                
                List {
                    ForEach(0..<habits.items.count) { index in
                        NavigationLink(
                            destination: HabitDetailView(habit: habits.items[index]),
                            label: {
                                Stepper(value: $habits.items[index].hours, in: 0...1000, step: 0.1) {
                                    VStack(alignment: .leading) {
                                        Text(habits.items[index].name)
                                            .fontWeight(.bold)
                                        Text(habits.items[index].hours == 1 ? "1 hour" : "\(habits.items[index].hours, specifier: "%g") Hours")
                                            .fontWeight(.regular)
                                    }
                                }
                            })
                    }
                }
                .navigationBarTitle("HabitTracker", displayMode: .inline)
                .navigationBarItems(leading: Button("+") {
                    showingAddHabitSheet = true
                }.foregroundColor(Color.green))
                .sheet(isPresented: $showingAddHabitSheet) {
                    AddHabitView(habits: self.habits)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
