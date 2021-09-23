//
//  ContentView.swift
//  Project #8 - Moonshot
//
//  Created by Bruno Benčević on 9/23/21.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var showingLaunchDates = true
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                            
                        if self.showingLaunchDates {
                            Text(mission.formattedLaunchDate)
                        } else {
                            Text(self.getCrewString(mission))
                        }
                    }
                }
            }
            .navigationBarItems(leading: Button(showingLaunchDates ? "Show Crew" : "Show Launch Date") {
                showingLaunchDates.toggle()
            })
            .navigationBarTitle("Moonshot")
        }
    }
    
    func getCrewString(_ mission: Mission) -> String {
        return mission.crew.reduce("", { last, member in
            last + member.name.capitalized + ", "
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
