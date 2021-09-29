//
//  ContentView.swift
//  Challenge #5 - Friends
//
//  Created by Bruno Benčević on 9/27/21.
//

import SwiftUI

struct MainView: View {
    let userDataService: UserDataService
    
    @StateObject var users = Users()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(users.items) { user in
                        NavigationLink(
                            destination: UserDetailView(user: user) ) {
                            UserCellView(user: user)
                        }
                    }
                }
                
                Button("Load people") {
                    userDataService.fetchUserData { fetchedUsers in
                        users.items += fetchedUsers
                    } onFail: { error in
                        print(error.localizedDescription)
                    }
                }
            }
            .navigationBarTitle("Friends")
        }
        .environmentObject(users)
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userDataService: OfflineUserDataService())
    }
}
