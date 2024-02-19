//
//  ContentView.swift
//  coloss
//
//  Created by Dev on 6.02.24.
//

import SwiftUI

struct MainScreen: View {
    
    @Binding var selection: AppScreen
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            TabView(selection: $selection) {
                ForEach(AppScreen.allCases) {screen in
                    screen.destination
                        .tabItem {screen.label}
                        .tag(screen)
                }
            }
        }
        
    }
    
}

#Preview {
    MainScreen(selection: .constant(.main))
}
