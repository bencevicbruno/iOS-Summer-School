//
//  ContentView.swift
//  Challenge #3 - MultiplicationHell
//
//  Created by Bruno Benčević on 9/22/21.
//

import SwiftUI

struct ContentView: View {
    @State private var difficulty = (1...12).randomElement()!
    @State private var amount = QuestionAmount.allCases.randomElement()!
    @State private var isInGame = false
    
    static var rounds = [QuestionRound]()
    static var currentRound = 0
    static var score = 0
    
    @State var showingAlert = false
    @State var alertTitle = ""
    
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.pink, .yellow]), startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            
            Form {
                HStack(alignment: .center) {
                    Spacer()
                    Text("Game Options")
                    Spacer()
                }
                
                Stepper(value: $difficulty, in: 1...12) {
                    Text("Difficulty: \(difficulty)")
                }
                
                Text("How many questions do you want?")
                
                Picker("How many questions do you want?", selection: $amount) {
                    ForEach(QuestionAmount.allCases, id: \.self) { amount in
                        Text("\(amount.rawValue)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                HStack(alignment: .center) {
                    Spacer()
                    Button("Start") {
                        startGame()
                        withAnimation {
                            isInGame = true
                        }
                    }
                    Spacer()
                }
            }
            .opacity(isInGame ? 0.0 : 1.0)
            
            if isInGame {
                VStack {
                    QuestionView(round: ContentView.rounds[ContentView.currentRound], onAnswerPressed: answerPressed)
                }.opacity(isInGame ? 1.0 : 0.0)
            }
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text(alertTitle), message: nil, dismissButton: .default(Text("OK"), action: {
                
                withAnimation {
                    ContentView.currentRound += 1
                }
                
            }))
        })
    }
    
    func startGame() {
        ContentView.rounds = QuestionGenerator.generateQuestions(maxFactor: difficulty, amount: Int(amount.rawValue) ?? -1).map {
            QuestionRound(question: $0)
        }
    }

    func answerPressed(answerPressed: Int) {
        let correctAnswer = ContentView.rounds[ContentView.currentRound].question.answer
        
        if answerPressed == correctAnswer {
            alertTitle = "Correct!"
            ContentView.score += 1
        } else {
            alertTitle = "False! It's actually \(correctAnswer)"
        }
        
        if ContentView.currentRound == ContentView.rounds.count - 1 {
            alertTitle = "Game over! Score: \(ContentView.score)"
            withAnimation {
                isInGame = false
            }
            ContentView.currentRound = 0
        } else {
            
        }
        
        showingAlert = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
