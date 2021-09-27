//
//  UserDataService.swift
//  Challenge #5 - Friends
//
//  Created by Bruno Benčević on 9/27/21.
//

import Foundation

protocol UserDataService {
    func fetchUserData(onSucces: @escaping ([User]) -> Void, onFail: ((Error) -> Void)?)
}

struct RealUserDataService: UserDataService {
    func fetchUserData(onSucces: @escaping ([User]) -> Void, onFail: ((Error) -> Void)?) {
        let userDataURL = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        
        URLSession.shared.dataTask(with: userDataURL) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let users = try decoder.decode([User].self, from: data)
                    
                    DispatchQueue.main.async {
                        onSucces(users)
                    }
                } catch {
                    onFail?(error)
                }
            } else {
                if let error = error {
                    onFail?(error)
                }
            }
        }.resume()
    }
}

struct OfflineUserDataService: UserDataService {
    func fetchUserData(onSucces: @escaping ([User]) -> Void, onFail: ((Error) -> Void)?) {
        onSucces([User.test(), User.test()])
    }
}
