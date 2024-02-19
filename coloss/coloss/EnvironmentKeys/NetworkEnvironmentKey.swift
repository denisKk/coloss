//
//  FirebaseEnvironmentKey.swift
//  coloss
//
//  Created by Dev on 13.02.24.
//

import SwiftUI

struct NetworkEnvironmentKey: EnvironmentKey {
    static var defaultValue: NetworkService = mocNetworkAPI()
}

extension EnvironmentValues {
    var networkAPI: (NetworkService) {
        get { self[NetworkEnvironmentKey.self] }
        set { self[NetworkEnvironmentKey.self] = newValue }
    }
}
