//
//  OnboardingScreen.swift
//  coloss
//
//  Created by Dev on 9.02.24.
//

import SwiftUI

struct OnboardingScreen: View {
    
    @EnvironmentObject private var user: UserModel
    
    var body: some View {
        ZStack {
            
            Color.background
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    Text("Welcome")
                        .font(.system(size: 33, weight: .light))
                }
                .frame(maxHeight: .infinity)
                
                VStack {
                    Text("To continue, you need to accept our\n terms of use")
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .font(.callout)
                        .padding(.horizontal, 24)
                        .frame(alignment: .center)
                    
                    Button {
                        user.createUser()
                    } label: {
                        Text(" Accept ")
                    }
                .buttonStyle(.bordered)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    OnboardingScreen()
}
