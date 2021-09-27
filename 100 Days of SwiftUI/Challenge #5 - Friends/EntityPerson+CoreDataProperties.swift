//
//  EntityPerson+CoreDataProperties.swift
//  Challenge #5 - Friends
//
//  Created by Bruno Benčević on 9/27/21.
//
//

import Foundation
import CoreData


extension EntityPerson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityPerson> {
        return NSFetchRequest<EntityPerson>(entityName: "EntityPerson")
    }

    @NSManaged public var myAbout: String?
    @NSManaged public var myAddress: String?
    @NSManaged public var myAge: Int16
    @NSManaged public var myCompany: String?
    @NSManaged public var myEmail: String?
    @NSManaged public var myID: UUID?
    @NSManaged public var myIsActive: Bool
    @NSManaged public var myName: String?
    @NSManaged public var myRegistered: Date?
    
    var about: String {
        return myAbout ?? "Empty"
    }
    
    var address: String {
        return myAddress ?? "Unknown"
    }
    
    var age: Int {
        return Int(myAge)
    }
    
    var company: String {
        return myCompany ?? "Unknown"
    }

    var email: String {
        return myEmail ?? "None"
    }
    
    public var id: String {
        return myID?.uuidString ?? UUID().uuidString
    }
    
    var isActive: Bool {
        return myIsActive
    }
    
    var name: String {
        return myName ?? "Mysterious Mystery"
    }
    
    var registerd: Date {
        return myRegistered ?? Date.distantPast
    }
}

extension EntityPerson : Identifiable {

}
