//
//  Question.swift
//  Challenge #3 - Multiplication Game
//
//  Created by Bruno Benčević on 9/21/21.
//

import Foundation

struct Question {
    let title: String
    let answer: Int
    
    init(factorA: Int, factorB: Int) {
        self.title = "What is \(factorA)x\(factorB)?"
        self.answer = factorA*factorB
    }
}

struct QuestionRound {
    let question: Question
    let answers: [Int]
    
    init(question: Question) {
        self.question = question
        
        let answer = question.answer
        let errorRange = 4...10
        self.answers = [answer, answer + errorRange.randomElement()!, answer - errorRange.randomElement()!].shuffled()
    }
}

enum QuestionAmount: String, CaseIterable {
    case five = "5"
    case ten = "10"
    case twenty = "20"
    case all = "All"
}

class QuestionGenerator {
    static func generateQuestions(maxFactor: Int, amount: Int) -> Array<Question> {
        if maxFactor < 1 {
            return Array()
        }
        
        var allQuestions = [Question]()
        
        for a in 1...maxFactor {
            for b in 1...maxFactor {
                allQuestions.append(Question(factorA: a, factorB: b))
            }
        }
        
        allQuestions.shuffle()
        
        if amount > allQuestions.count || amount == -1 {
            return allQuestions
        }
        
        return Array(allQuestions.prefix(upTo: amount))
    }
}
