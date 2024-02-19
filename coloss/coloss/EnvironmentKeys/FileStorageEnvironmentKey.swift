//
//  FileStorageEnvironmentKey.swift
//  coloss
//
//  Created by Dev on 15.02.24.
//

import SwiftUI

struct FileStorageEnvironmentKey: EnvironmentKey {
    static var defaultValue: StorageService = MocStorageService()
}

extension EnvironmentValues {
    var storageAPI: (StorageService) {
        get { self[FileStorageEnvironmentKey.self] }
        set { self[FileStorageEnvironmentKey.self] = newValue }
    }
}

