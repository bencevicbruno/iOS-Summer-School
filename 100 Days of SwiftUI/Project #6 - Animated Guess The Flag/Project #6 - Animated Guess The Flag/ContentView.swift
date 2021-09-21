//
//  ContentView.swift
//  Project #6 - Animated Guess The Flag
//
//  Created by Bruno Benčević on 9/21/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var totalScore = 0
    @State private var selectedAnswer = 0
    
    static private var correctFlagRotation = 0.0
    static private var falseOpacity = 1.0
    static private var falseColor = Color.white
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                .foregroundColor(.black)
                
                Spacer()
                
                ForEach(0..<3) { number in
                    Button(action: {
                        withAnimation {
                            ContentView.correctFlagRotation += 360
                            ContentView.falseOpacity = 0.25
                            ContentView.falseColor = .red
                        }
                        self.flagTapped(number)
                        
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black, radius: 5)
                            .rotation3DEffect(
                                .degrees(number == correctAnswer ? ContentView.correctFlagRotation : 0.0),
                                axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
                            )
                            .opacity(number == correctAnswer ? 1.0 : ContentView.falseOpacity)
                            .animation(.default)
                    }
                }
                
                Spacer()
                
                Text("Total score: \(totalScore)")
                    .foregroundColor(.black)
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text((scoreTitle == "Wrong" ? "That is actually \(countries[selectedAnswer]).\n" : "") + "Score: \(totalScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            totalScore += 1
        } else {
            scoreTitle = "Wrong"
            totalScore -= 1
        }
        
        selectedAnswer = number
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        ContentView.falseOpacity = 1.0
        ContentView.correctFlagRotation = 0
        ContentView.falseColor = .white
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
