//
//  LocalDataService.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import Foundation
import UIKit

class LocalDataService {
    let peopleURL = FileManager.default.getUserDirectory().appendingPathComponent("people.json")
    
    func saveData(_ people: [Person], onFail: onFail?) {
        var peopleData: Data
        
        do {
            peopleData = try JSONEncoder().encode(people)
        } catch {
            onFail?("Encoding [Person] failed: \(error.localizedDescription)")
            return
        }
        
        var imagesData = [UUID: Data]()
        
        for person in people {
            guard let jpegData = person.image.jpegData(compressionQuality: 0.8) else {
                onFail?("Encoding image for \(person.id.uuidString) failed!")
                return
            }
            imagesData[person.id] = jpegData
        }
        
        writeData(peopleData, imagesData, onFail)
    }
    
    private func writeData(_ peopleData: Data, _ imagesData: [UUID: Data], _ onFail: onFail?) {
        do {
            try peopleData.write(to: peopleURL, options: [.atomic, .completeFileProtection])
            
            try imagesData.forEach {
                let imageURL = FileManager.default.getUserDirectory().appendingPathComponent("\($0.key.uuidString).png")
                try $0.value.write(to: imageURL, options: [.atomic, .completeFileProtection])
            }
        } catch {
            onFail?("Saving data failed: \(error.localizedDescription)")
        }
    }
    
    func loadData(onSuccess: onSuccess<[Person]>, onFail: onFail?) {
        var people = [Person]()
        
        do {
            people = try JSONDecoder().decode([Person].self, from: Data(contentsOf: peopleURL))
        } catch {
            onFail?("Loading people data failed: \(error.localizedDescription)")
        }
        
        for person in people {
            let imageURL = FileManager.default.getUserDirectory().appendingPathComponent("\(person.id.uuidString).png")
            var imageData: Data
            
            do {
                imageData = try Data(contentsOf: imageURL)
            } catch {
                onFail?("Failed loading image: \(error.localizedDescription)")
                return
            }
            
            if let uiImage = UIImage(data: imageData) {
                person.image_ = uiImage
            } else {
                onFail?("Unable to create ")
            }
        }
        
        onSuccess(people)
    }
}

