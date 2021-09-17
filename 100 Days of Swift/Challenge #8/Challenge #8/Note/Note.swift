//
//  Note.swift
//  Challenge #8
//
//  Created by Bruno Benčević on 8/18/21.
//

import UIKit

extension String {
    func substringBefore(_ string: String) -> String {
        if let range = self.range(of: string) {
            return String(self[..<range.lowerBound])
        }
        
        return self
    }
    
    func substringAfter(_ string: String) -> String {
        if let range = self.range(of: string) {
            return String(self[range.lowerBound..<self.endIndex])
        }
        
        return self
    }
}

struct Note: Codable, Hashable {
    var title: String
    var date: Date
    var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.date = Date()
        self.body = body
    }
    
    func getDateDetails() -> String {
        let description = date.description(with: Locale.current)
        
        if description.contains("AM") {
            return "\(description.substringBefore("AM"))AM"
        } else if description.contains("PM") {
            return "\(description.substringBefore("PM"))PM"
        }
        
        return description
    }
    
    func toRawText() -> String {
        return "[\(self.title) | \(self.getDateDetails())]: \(self.body)"
    }
    
    func isEmpty() -> Bool {
        return self.title == "" && self.body == ""
    }
    
    func save() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("note_\(self.title).json")
        
        do {
            try JSONEncoder().encode(self).write(to: path)
        } catch {
            print("Failed to save Note titled \(title)!")
        }
    }
    
    static func load(title: String) -> Note {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("note_\(title).json")
        
        do {
            return try JSONDecoder().decode(Note.self, from: Data(contentsOf: path))
        } catch  {
            print("Failed to load Note titled \(title)! Returning empty note!")
            return Note(title: "", body: "")
        }
    }
}
