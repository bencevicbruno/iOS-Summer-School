//
//  QuestionView.swift
//  Challenge #3 - MultiplicationHell
//
//  Created by Bruno Benčević on 9/22/21.
//

import SwiftUI

struct QuestionView: View {
    static var colors = [Color(red: 189.0 / 255, green: 219.0 / 255, blue: 188.0 / 255),
                  Color(red: 219.0 / 255, green: 208.0 / 255, blue: 232.0 / 255),
                  Color(red: 190.0 / 255, green: 197.0 / 255, blue: 221.0 / 255)]
    var round: QuestionRound
    
    var onAnswerPressed: (Int) -> Void
    
    var body: some View {
        VStack {
            Text(round.question.title)
                .font(Font.system(size: 40))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom)
            
            HStack {
                ForEach(0..<3) { index in
                    Button {
                        onAnswerPressed(round.answers[index])
                    } label : {
                        Text("\(round.answers[index])")
                            .font(Font.system(size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                            .background(QuestionView.colors[index])
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                }
            }
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(round: QuestionRound(question: Question(factorA: 5, factorB: 6))) { i in
            print( i )
        }
    }
}
