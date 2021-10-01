//
//  ContentView.swift
//  Project #18 - LayoutAndGeometry
//
//  Created by Bruno Benčević on 10/1/21.
//

import SwiftUI

extension VerticalAlignment {
    struct MidAccountAndName: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.top]
        }
    }
    
    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<50) { index in
                        GeometryReader { geo in
                            Rectangle()
                                .fill(self.colors[index % 7])
                                .frame(height: 150)
                                .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - fullView.size.width / 2) / 10), axis: (x: 0, y: 1, z: 0))
                        }
                        .frame(width: 150)
                    }
                }
                .padding(.horizontal, (fullView.size.width - 150) / 2)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    //
    //    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    //
    //    var body: some View {
    //        GeometryReader { fullView in
    //            ScrollView(.vertical) {
    //                ForEach(0..<50) { index in
    //                    GeometryReader { geo in
    //                        Text("Row #\(index)")
    //                            .font(.title)
    //                            .frame(width: fullView.size.width)
    //                            .background(self.colors[index % 7])
    //                            .rotation3DEffect(.degrees(Double(geo.frame(in: .global).minY - fullView.size.height / 2) / 5), axis: (x: 0, y: 1, z: 0))
    //                    }
    //                    .frame(height: 40)
    //                }
    //            }
    //        }
    //    }
    //    var body: some View {
    //        VStack(alignment: .leading) {
    //            ForEach(0..<10) { position in
    //                Text("Number \(position)")
    //                    .alignmentGuide(.leading) { _ in CGFloat(position) * -10 }
    //            }
    //        }
    //        .background(Color.red)
    //        .frame(width: 400, height: 400)
    //        .background(Color.blue)
    
    //        HStack(alignment: .midAccountAndName) {
    //            VStack {
    //                Text("@twostraws")
    //                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
    //                Image("random")
    //                    .resizable()
    //                    .frame(width: 64, height: 64)
    //            }
    //
    //            VStack {
    //                Text("Full name:")
    //                Text("PAUL HUDSON")
    //                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
    //                    .font(.largeTitle)
    //            }
    //        }
    //    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
