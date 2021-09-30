//
//  PersonCellView.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import SwiftUI

struct PersonCellView: View {
    let person: Person
    
    var body: some View {
        HStack {
            Image(uiImage: person.image)
                .resizable()
                .frame(width: 55, height: 55)
                .clipShape(Circle())
                .shadow(radius: 10)
            
            VStack(alignment: .leading) {
                Text("\(person.firstName) \(person.lastName)")
                    .font(Font.system(.title2))
                    .fontWeight(.medium)
                
                Text(person.id.uuidString)
                    .font(Font.system(size: 10))
                    .fontWeight(.thin)
            }
        }
        .frame(height: 60)
    }
}

struct PersonCellView_Previews: PreviewProvider {
    static var previews: some View {
        PersonCellView(person: Person.test())
    }
}
