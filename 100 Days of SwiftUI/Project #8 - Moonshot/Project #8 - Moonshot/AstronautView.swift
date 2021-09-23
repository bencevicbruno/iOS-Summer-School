//
//  AstronautView.swift
//  Project #8 - Moonshot
//
//  Created by Bruno Benčević on 9/23/21.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let missionsList: [Mission]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                    
                    Text("Missions")
                        .fontWeight(.heavy)
                    
                    ForEach(missionsList) { mission in
                        VStack {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(.top)
                            
                            Text("Launch date: \(mission.formattedLaunchDate)")
                                .fontWeight(.bold)
                                .padding()
                        }
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
    
    init(astronaut: Astronaut, missionsIn: [Mission]?) {
        self.astronaut = astronaut
        
        var selfMissions = [Mission]()
        let astronautID = self.astronaut.id
        
        if let missionsIn = missionsIn {
            missionsIn.forEach { mission in
                mission.crew.forEach { crewMember in
                    if crewMember.name == astronautID {
                        selfMissions.append(mission)
                        return
                    }
                }
            }
        }
        
        self.missionsList = selfMissions
    }
}

struct AstronautView_Previews: PreviewProvider {
    static var previews: some View {
        AstronautView(astronaut: Astronaut(id: "dummy", name: "Lorem ipsum", description: "hehe iks de"), missionsIn: nil)
    }
}
