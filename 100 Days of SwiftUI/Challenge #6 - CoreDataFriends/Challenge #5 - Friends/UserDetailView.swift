//
//  UserDetailView.swift
//  Challenge #5 - Friends
//
//  Created by Bruno Benčević on 9/27/21.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    var users: FetchRequest<EntityPerson>
    
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
                    Text("Not working atm as saving arrays in CoreData is rather complicated...")
                }
            }
        }
    }
    
    var friends: [User] {
        var allFriends = [User]()
        
        users.wrappedValue.forEach { thisUser in
            user.friends.forEach { friend in
                print(thisUser.id, friend.id, thisUser.id == friend.id)
                if thisUser.id == friend.id {
                    allFriends.append(thisUser.toStruct())
                }
            }
        }
        print(allFriends)
        return allFriends
    }
}


struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: User.test(), users: FetchRequest(entity: EntityPerson.entity(), sortDescriptors: []))
    }
}
