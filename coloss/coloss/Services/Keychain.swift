//
//  SecureStorage.swift
//  coloss
//
//  Created by Dev on 9.02.24.
//

import Foundation

import Security

protocol SecureService {
    func loadID() async -> String?
    func deleteID() async
    func saveID(_ id: String) async
}

actor Keychain: SecureService {
    
    private func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    private func delete(key: String) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key] as [String : Any]
        return  SecItemDelete(query as CFDictionary)
    }
    
    private func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
    
}

// MARK: Keys {
private extension Keychain {
    enum Keys: String {
        case password = "Coloss login"
        case userId = "Coloss user"
    }
}

// MARK: Password
extension Keychain {
    
    func savePassword(_ password: String) {
        let data = password.data(using: String.Encoding.utf8)!
        let status = save(key: Keys.password.rawValue, data: data)
        print("status save: ", status)
    }
    
    func deletePassword() {
        
        let status = delete(key: Keys.password.rawValue)
        print("status delete: ", status)
    }
    
    func loadPassword() -> String? {
        if let receivedData = load(key: Keys.password.rawValue) {
            let result =  String(data: receivedData, encoding: String.Encoding.utf8)
            print("result load: " + (result ?? "no pass"))
            return result
        }
        return nil
    }
}

// MARK: ID
extension Keychain {
    
    func saveID(_ id: String) {
        let data = id.data(using: String.Encoding.utf8)!
        let status = save(key: Keys.userId.rawValue, data: data)
        print("status save: ", status)
    }
    
    func deleteID() {
        let status = delete(key: Keys.userId.rawValue)
        print("status delete: ", status)
    }
    
    func loadID() -> String? {
        if let receivedData = load(key: Keys.userId.rawValue) {
            let result =  String(data: receivedData, encoding: String.Encoding.utf8)
            print("result load: " + (result ?? "no id"))
            return result
        }
        return nil
    }
}
