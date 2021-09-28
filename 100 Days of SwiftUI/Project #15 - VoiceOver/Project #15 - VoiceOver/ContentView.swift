//
//  ContentView.swift
//  Project #15 - VoiceOver
//
//  Created by Bruno Benčević on 9/28/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            Text("Hello, world! Again...")
        }
        .accessibilityElement(children: .ignore)
        // No need to listen to something on repeast
        
        Group {
            Text("This is a 5-star restaurant")
                .accessibility(hint: Text("5 star restaurant"))
            Button("Click me") {
                Image(systemName: "pencil")
            }
            .accessibilityElement(children: .ignore)
            .accessibility(hint: Text("Pencil button"))
        }
        
        // CupcakeCorner
        // .accessEleemnt on checkout for its image should be ignored
        
        
        // BetterRest
        // the stepper should read its value saying "Time slept xyz hours"
        // made using accessElement children: .ignore
        
        // Moonshot
        // to make it fully accessible:
        // reading images
        // saying that texts can be clicked
        // when reading friends - say that anything can be clicked
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
