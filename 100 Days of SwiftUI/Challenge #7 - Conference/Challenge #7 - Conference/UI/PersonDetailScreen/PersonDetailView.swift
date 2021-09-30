//
//  PersonDetailView.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import SwiftUI

struct PersonDetailView: View {
    let person: Person
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .white, Color(red: 0.9, green: 0.6, blue: 0.4)]), startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .center, spacing: 20) {
                Image(uiImage: person.image)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 30)
                
                Text("\(person.firstName) \(person.lastName)")
                    .font(Font.system(.largeTitle))
                    .fontWeight(.bold)
                
                Text(person.id.uuidString)
                    .font(Font.system(size: 10))
            }
        }
    }
}

struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PersonDetailView(person: Person.test())
    }
}
