//
//  ContentView.swift
//  Project #5 - WordScramble
//
//  Created by Bruno Benčević on 9/21/21.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    static private var score = 0
    
    init() {
        UITableView.appearance().backgroundColor = .none
        UITableViewCell.appearance().backgroundColor = .white.withAlphaComponent(0.7)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .white, .white, .white, .white]), startPoint: .bottom, endPoint: .top)
                
                VStack {
                    TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .padding()
                    
                    List(0..<usedWords.count) { index in
                        GeometryReader { rowGeo in
                            HStack {
                                Image(systemName: "\(usedWords[index].count).circle")
                                Text(usedWords[index])
                            }
                            .foregroundColor(Color(red: 0.0, green: 0.0, blue: 1.0 / Double(index + 1)))
                            .offset(x: max(rowGeo.frame(in: .global).maxY / rowGeo.frame(in: .local).maxY - 10, 0), y: 0)
                        }
                    }
                    
                    Text("Score: \(ContentView.score)")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            
            .navigationBarTitle(rootWord)
            .navigationBarItems(leading: Button("Restart", action: startGame).foregroundColor(.blue))
        }
        .onAppear(perform: startGame)
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0
                && isLongEnough(word: answer)
                && isOriginal(word: answer)
                && isPossible(word: answer)
                && isPossible(word: answer)
        else {
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
        ContentView.score += answer.count
    }
    
    func isLongEnough(word: String) -> Bool {
        return word.count >= 3
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func startGame() {
        usedWords.removeAll()
        usedWords = [String](repeating: "test", count: 10)
        newWord = ""
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
