//
//  StoreModel.swift
//  coloss
//
//  Created by Dev on 9.02.24.
//

import Foundation


@MainActor
final class UserModel: ObservableObject {
    
    private var authService: AuthService
    private var secureService: SecureService
    
    
    init(authService: AuthService, secureService: SecureService) {
        self.authService = authService
        self.secureService = secureService
    }
    
    
    @Published var userId: String?
    
    func loadUserId() async {
        Task {
            userId = await secureService.loadID()
        }
    }
    
    
    func createUser() {
        Task {
            let newId = String.generateRandom(size: 15)
            await secureService.saveID(newId)
            userId = newId
        }
    }
    
    func deleteUser() {
        Task {
            await secureService.deleteID()
        }
    }
}
