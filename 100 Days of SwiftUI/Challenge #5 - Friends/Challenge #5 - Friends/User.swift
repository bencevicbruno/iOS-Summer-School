//
//  Person.swift
//  Challenge #5 - Friends
//
//  Created by Bruno Benčević on 9/27/21.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: String
    let friends: [Friend]
    
    struct Friend: Codable, Identifiable {
        let id: String
        let name: String
    }
    
    var dateRegistered: String {
        let dateFormatterForEncoding = DateFormatter()
        dateFormatterForEncoding.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatterForEncoding.date(from: registered) ?? Date.distantPast
        
        let dateFormatterForDecoding = DateFormatter()
        dateFormatterForDecoding.dateFormat = "yyy-MM-dd"
        dateFormatterForDecoding.dateStyle = .medium
        
        return dateFormatterForDecoding.string(from: date)
    }
    
    static func test() -> User {
        return User(id: "test", isActive: true, name: "Bruno Bench", age: 22, company: "geyoten d.o.o.", email: "brb@gmail.com", address: "Somewhere", about: "Iz me", registered: "never", friends: [Friend(id: "legafrend", name: "Lega"), Friend(id: "friendtest", name: "Lega #2")])
    }
}

class Users: ObservableObject {
    @Published var items = [User]()
}


