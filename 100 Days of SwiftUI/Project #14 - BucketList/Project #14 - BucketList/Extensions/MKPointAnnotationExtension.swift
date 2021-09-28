//
//  MKPointAnnotationExtension.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import Foundation
import MapKit

extension MKPointAnnotation: ObservableObject {
    // Wrapped values are not published
    // We're not showing these properties, rather editing them
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }
        
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }
        
        set {
            subtitle = newValue
        }
    }
}

// Ways to make MkPointAnnotation codable:
// 1) make a subclass
// 2) make struct wrapper
// 3) create custom PointAnnotation implementing MKAnnotation protocol

class CodableMKPointAnnotation: MKPointAnnotation, Codable {
    enum CodingKeys: CodingKey {
        case title, subtitle, latitude, longitude
    }
    
    override init() {
        super.init()
    }
    
    public required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.subtitle = try container.decode(String.self, forKey: .subtitle)
        
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.wrappedTitle, forKey: .title)
        try container.encode(self.wrappedSubtitle, forKey: .subtitle)
        try container.encode(self.coordinate.latitude, forKey: .latitude)
        try container.encode(self.coordinate.longitude, forKey: .longitude)
    }
}
