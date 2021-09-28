//
//  AppDataService.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import Foundation

class AppDataService {
    let fileURL = FileManager.default.userDirectoryURL.appendingPathComponent("SavedPlaces")
    
    func loadData(onSuccess: @escaping ([CodableMKPointAnnotation]) -> Void, onFail: (String) -> Void) {
        do {
            let data = try Data(contentsOf: fileURL)
            let locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
            
            onSuccess(locations)
        } catch {
            onFail(error.localizedDescription)
        }
    }
    
    func saveData(_ data: [CodableMKPointAnnotation], onSucces: @escaping () -> Void, onFail: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(data)
                try data.write(to: self.fileURL, options: [.atomicWrite, .completeFileProtection])
            } catch {
                onFail(error.localizedDescription)
            }
        }
    }
}
