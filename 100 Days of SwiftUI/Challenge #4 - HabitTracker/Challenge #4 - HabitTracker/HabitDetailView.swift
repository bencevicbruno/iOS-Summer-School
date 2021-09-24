//
//  HabitDetailView.swift
//  Challenge #4 - HabitTracker
//
//  Created by Bruno Benčević on 9/23/21.
//

import SwiftUI

struct HabitDetailView: View {
    let Background = LinearGradient(gradient: Gradient(colors: [Color(red: 1.0, green: 0.8, blue: 0.8), .white, .white]), startPoint: .bottom, endPoint: .top)
    
    @State var habit: Habit
    
    var body: some View {
        NavigationView {
            ZStack {
                Background
                
                VStack(alignment: .center) {
                    Image(systemName: habit.sfImageName ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                    
                    Text(habit.name)
                        .fontWeight(.bold)
                        .font(Font.system(size: 20))
                        .padding()
                    
                    Text(habit.description ?? "")
                        .fontWeight(.semibold)
                        .padding()
                    
                    Spacer()
                }
                .padding()
            }
            
        }
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(habit: Habit(name: "Dancing", description: "Time to dance!", sfImageName: nil, hours: 1.3))
    }
}
