//
//  ContentView.swift
//  Project #9 - Drawing
//
//  Created by Bruno Benčević on 9/23/21.
//

import SwiftUI

struct Arrow: InsettableShape {
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX + insetAmount, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX * 3 / 4, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX * 3 / 4, y: rect.minY + insetAmount))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX * 3 / 4, y: rect.maxY - insetAmount))
        path.addLine(to: CGPoint(x: rect.maxX * 3 / 4, y: rect.midY))
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
    
    var animatableData: CGFloat {
        get { insetAmount }
        set { self.insetAmount = newValue }
    }
}

struct RainbowRectangle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX + 10, y: rect.minY + 10))
        path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.minY + 10))
        path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.maxX - 10))
        path.addLine(to: CGPoint(x: rect.minX + 10, y: rect.maxX - 10))
        path.addLine(to: CGPoint(x: rect.minX + 10, y: rect.minY + 10))
        
        return path
    }
}

struct ContentView: View {
    @State private var lineWidth: CGFloat = 5.0
    @State private var squareColor = Color.red
    
    var body: some View {
        VStack {
            Arrow()
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .bevel))
                .frame(width: 100, height: 100)
                .background(Color.yellow)
                .animation(.easeInOut)
            
            
            Stepper("Stroke Width", value: $lineWidth, in: 1...10)
            
            Rectangle()
                .fill(squareColor)
                .frame(width: 100, height: 100)
            
            Button("Change Color") {
                withAnimation { // lazy way of doing it
                    squareColor = squareColor == Color.red ? Color.blue : Color.red
                }
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
