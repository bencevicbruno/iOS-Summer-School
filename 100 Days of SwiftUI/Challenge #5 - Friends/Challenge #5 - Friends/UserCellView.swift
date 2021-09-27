//
//  UserCellView.swift
//  Challenge #5 - Friends
//
//  Created by Bruno Benčević on 9/27/21.
//

import SwiftUI

struct UserCellView: View {
    let user: User
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(user.isActive ? Color.green : Color.red)
            
            VStack(alignment: .leading) {
                Text("\(user.name) (\(user.age))")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(user.email)
                    .font(.subheadline)
                    .fontWeight(.thin)
            }
            .frame(height: 35)
            
            Spacer()
        }
    }
}

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserCellView(user: User.test())
    }
}
