//
//  FileManagerExtensions.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import Foundation

extension FileManager {
    public var userDirectoryURL: URL {
        self.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
