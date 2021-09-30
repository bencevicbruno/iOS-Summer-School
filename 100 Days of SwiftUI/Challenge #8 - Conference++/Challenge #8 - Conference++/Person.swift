//
//  Person.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import Foundation
import UIKit
import CoreLocation

class Person: Identifiable, Equatable, Comparable, Codable {
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, latitude, longitude
    }
    
    let id: UUID
    let firstName: String
    let lastName: String
    var image_: UIImage?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    var image: UIImage {
        return image_ ?? UIImage(systemName: "xmark.octagon")!
    }
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
    }
    
    init(id: UUID, firstName: String, lastName: String, image: UIImage) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.image_ = image
    }
    
    convenience init(firstName: String, lastName: String, image: UIImage) {
        self.init(id: UUID(), firstName: firstName, lastName: lastName, image: image)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.image_ = nil
        self.latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        self.longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encode(self.lastName, forKey: .lastName)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
    }
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        if lhs.firstName == rhs.firstName {
            return lhs.lastName < rhs.lastName
        } else {
            return lhs.firstName < rhs.firstName
        }
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func test() -> Person {
        return Person(firstName: "Testo", lastName: "Testing", image: UIImage(systemName: "pencil")!)
    }
}
