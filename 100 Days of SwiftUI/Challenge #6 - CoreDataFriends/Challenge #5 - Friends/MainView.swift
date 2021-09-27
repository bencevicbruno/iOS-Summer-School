//
//  ContentView.swift
//  Challenge #5 - Friends
//
//  Created by Bruno Benčević on 9/27/21.
//

import SwiftUI

struct MainView: View {
    var userDataService: UserDataService
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: EntityPerson.entity(), sortDescriptors: []) var users: FetchedResults<EntityPerson>
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(users, id: \.self) { user in
                        NavigationLink(
                            destination: UserDetailView(user: user.toStruct(), users: _users) ) {
                            UserCellView(user: user.toStruct())
                        }
                    }
                }
                
                HStack {
                    Button("Load people") {
                        userDataService.fetchUserData { fetchedUsers in
                            fetchedUsers.forEach { user in
                                let newUser = EntityPerson(context: self.moc)
                                newUser.myID = UUID(uuidString: user.id)
                                newUser.myName = user.name
                                newUser.myAge = Int16(user.age)
                                newUser.myEmail = user.email
                                newUser.myCompany = user.company
                                newUser.myAbout = user.about
                                newUser.myAddress = user.address
                                newUser.myIsActive = user.isActive
                            }
                            
                            try? self.moc.save()
                        } onFail: { error in
                            print(error.localizedDescription)
                        }
                    }
                    
                    Button("Delete people") {
                        for object in users {
                            self.moc.delete(object)
                        }
                    }
                }
            }
            .navigationBarTitle("Friends")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userDataService: OfflineUserDataService())
    }
}
