//
//  ContentView.swift
//  Project #3 - Views & Modifiers
//
//  Created by Bruno Benčević on 9/18/21.
//

import SwiftUI

struct LargeBlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .font(.largeTitle)
    }
}

extension View {
    func largeBlueTitle() -> some View {
        self.modifier(LargeBlueTitle())
    }
}

struct FlagImageView: View {
    let image: String
    let color: Color
    
    var body: some View {
        Image(systemName: image)
            .frame(width: 50, height: 50)
            .foregroundColor(color)
            .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 5)
    }
}

struct ContentView: View {
    @State private var tipPercentageIndex = 0
    
    let tipPercentages = [10, 15, 20, 25, 0]
    let images = ["pencil", "eye", "trash", "scribble", "cross"]
    
    var body: some View {
        Form {
            Text("Views & Modifiers")
                .largeBlueTitle()
            
            Picker("Choose tip percentage", selection: $tipPercentageIndex) {
                ForEach(0..<tipPercentages.count) {
                    Text("\(tipPercentages[$0])")
                }
            }
            .colorMultiply(tipPercentages[tipPercentageIndex] == 0 ? .red : .gray)
            .pickerStyle(SegmentedPickerStyle())
            
            HStack(alignment: .center) {
                ForEach(images, id: \.self) {
                    FlagImageView(image: $0, color: .blue)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
