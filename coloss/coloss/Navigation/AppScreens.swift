//
//  ApplicationScreen.swift
//  coloss
//
//  Created by Dev on 9.02.24.
//

import SwiftUI

enum AppScreen: Int, Hashable, Identifiable, CaseIterable {
    
    case main
    case plants
    case profile
    
    var id: AppScreen { self }
}


extension AppScreen {
    
    @ViewBuilder
    var label: some View {
        switch self {
            case .main:
                Label("Home", systemImage: "house.fill")
            case .profile:
                Label("Profile", systemImage: "person.fill")
            case .plants:
                Label("Plants", systemImage: "leaf")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .main:
                MainTabScreen()
            case .profile:
                ProfileTabScreen()
            case .plants:
               PlantsTabScreen()
        }
    }
    
}
