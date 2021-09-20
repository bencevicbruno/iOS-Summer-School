//
//  ContentView.swift
//  Challenge #2 - Rock, Paper, Scissors
//
//  Created by Bruno Benčević on 9/20/21.
//

import SwiftUI

enum Icon: String, CaseIterable {
    case ROCK = "cube.fill"
    case PAPER = "doc.plaintext.fill"
    case SCISSORS = "scissors"
}

struct ContentView: View {
    @State private var needsToWin = Bool.random()
    @State private var score = 0
    @State private var roundIcon = Icon.allCases.randomElement()
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage: String? = ""
    @State private var alertDismiss = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .white, Color(red: 250/255, green: 241/255, blue: 216/255, opacity: 1.0)]), startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 50) {
                VStack {
                    Text("you need to")
                        .font(Font.system(size: 20))
                        .fontWeight(.semibold)
                    
                    Text(needsToWin ? "WIN" : "LOSE")
                        .foregroundColor(needsToWin ? .green : .red)
                        .font(Font.system(size: 40))
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Image(systemName: roundIcon!.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Spacer()
                
                HStack(spacing: 30) {
                    Button(action: {
                        onTappedRock()
                    }, label: {
                        Image(systemName: "cube.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    })
                    
                    Button(action: {
                        onTappedPaper()
                    }, label: {
                        Image(systemName: "doc.plaintext.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    })
                    
                    Button(action: {
                        onTappedScissors()
                    }, label: {
                        Image(systemName: "scissors")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    })
                }
                .foregroundColor(.black)
                
                Text("score: \(score)")
                    .font(Font.system(size: 20))
                    .bold()
                    .padding(.bottom)
            }
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text(alertTitle), message: alertMessage != nil ? Text(alertMessage!) : nil, dismissButton: .default(Text(alertDismiss), action: {
                    nextRound()
            }))
        })
    }
    
    func onTappedRock() {
        switch roundIcon {
        case .ROCK:
            onMiss()
            break
        case .PAPER:
            needsToWin ? onLose() : onWin()
            break
        case .SCISSORS:
            needsToWin ? onWin() : onLose()
            break
        default:
            onWTF()
            break
        }
    }
    
    func onTappedPaper() {
        switch roundIcon {
        case .ROCK:
            needsToWin ? onWin() : onLose()
            break
        case .PAPER:
            onMiss()
            break
        case .SCISSORS:
            needsToWin ? onLose() : onWin()
            break
        default:
            onWTF()
            break
        }
    }
    
    func onTappedScissors() {
        switch roundIcon {
        case .ROCK:
            needsToWin ? onLose() : onWin()
            break
        case .PAPER:
            needsToWin ? onWin() : onLose()
            break
        case .SCISSORS:
            onMiss()
            break
        default:
            onWTF()
            break
        }
    }
    
    func onWin() {
        score += 1
        showAlert("Nice one!", dismiss: "Mucho grazie!")
    }
    
    func onMiss() {
        showAlert("You aren't very wise, aren't ya?", "Choose wisely next time!")
    }
    
    func onLose() {
        score -= 1
        showAlert("Better luck next time!", dismiss: "Let's go!")
    }
    
    func onWTF() {
        showAlert("What the hell did you press???", dismiss: "Don't know...")
    }
    
    func showAlert(_ title: String, _ message: String? = nil, dismiss: String = "OK") {
        alertTitle = title
        alertMessage = message
        alertDismiss = dismiss
        showingAlert = true
    }
    
    func nextRound() {
        var nextRoundIcon = roundIcon
        
        while (nextRoundIcon == roundIcon) {
            nextRoundIcon = Icon.allCases.randomElement()
        }
        
        roundIcon = nextRoundIcon
        needsToWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
