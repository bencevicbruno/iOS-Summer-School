//
//  Prospect.swift
//  Project #16 - HotProspects
//
//  Created by Bruno Benčević on 9/30/21.
//

import SwiftUI

class Prospect: Identifiable, Codable, Comparable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    
    static func ==(lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.name == rhs.name
            && lhs.emailAddress == rhs.emailAddress
            && lhs.isContacted == rhs.isContacted
    }
    
    static func <(lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.name < rhs.name
    }
}

class Prospects: ObservableObject {
    static let saveKey = "SavedData"
    static let saveURL = FileManager.getDirectory().appendingPathComponent(saveKey)
    
    @Published private(set) var people: [Prospect]
    
    init() {
//        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
        if let data = try? Data(contentsOf: Self.saveURL) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
        
        self.people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            try? encoded.write(to: Self.saveURL, options: [.atomic, .completeFileProtection])
//            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}

extension FileManager {
    static func getDirectory() -> URL {
        return Self.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
