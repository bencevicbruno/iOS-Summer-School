//
//  UserDetailView.swift
//  Challenge #5 - Friends
//
//  Created by Bruno Benčević on 9/27/21.
//

import SwiftUI

struct UserDetailView: View {
    @EnvironmentObject var users: Users
    let user: User
    
    var body: some View {
        VStack {
            Form {
                UserCellView(user: user)
                
                Text("Works at: \(user.company)")
                
                Text("Address: \(user.address)")
                
                Text("Registered: \(user.dateRegistered)")
                
                Section(header: Text("Bio")) {
                    Text(user.about)
                    
                }
                
                Section(header: Text("Friends")) {
                    ForEach(friends) { friend in
                        NavigationLink(
                            destination: UserDetailView(user: friend),
                            label: {
                                UserCellView(user: friend)
                            })
                    }
                }
            }
        }
    }
    
    var friends: [User] {
        var allFriends = [User]()
        
        users.items.forEach { thisUser in
            user.friends.forEach { friend in
                if thisUser.id == friend.id {
                    allFriends.append(thisUser)
                }
            }
        }
        
        return allFriends
    }
}


struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: User.test())
    }
}
