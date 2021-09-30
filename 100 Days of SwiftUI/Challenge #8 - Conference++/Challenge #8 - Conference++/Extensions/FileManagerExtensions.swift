//
//  FileManagerExtensions.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import Foundation

extension FileManager {
    
    func getUserDirectory() -> URL{
        return self.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
