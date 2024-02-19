//
//  LoadingScreen.swift
//  coloss
//
//  Created by Dev on 10.02.24.
//

import SwiftUI

struct LoadingScreen: View {
    
    @EnvironmentObject private var user: UserModel
    @State private var isLoading: Bool = true
    
    @AppStorage("selectionTab") var selectionTab: AppScreen = .main
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            switch user.userId {
            case nil:
                OnboardingScreen()
            case .some(let userId):
                MainScreen(selection: $selectionTab)
                    .environment(\.networkAPI, FirebaseFirestore(userId: userId))
                    .environment(\.storageAPI, FirebaseStorage(userId: userId))
            }

            
        }
        .task {
           // await model.deleteUser()
            await user.loadUserId()
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            self.isLoading = false
        }
        .overlay {
            if isLoading  {
                loadingView
            }
        }
        
    }
    
    @ViewBuilder
    var loadingView: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack {
                Text("Loading")
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
    
}

#Preview {
    LoadingScreen()
        .environmentObject(UserModel(authService: AuthServiceImpl(), secureService: Keychain()))
}
