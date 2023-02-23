//
//  KeychainService.swift
//  EventPasser
//
//  Created by Arseniy Matus on 06.12.2022.
//

import Foundation


@available(*, deprecated)
struct KeychainService {
    private init() { }
    
    static var shared: KeychainService { KeychainService() }
    
    func savePassword(service: String, email: String, password: String) throws {
        let securePassword = password.data(using: String.Encoding.utf8)
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: email as AnyObject,
            kSecValueData as String: securePassword as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecUnknownFormat else {
            throw KeychainError.invalidItemFormat
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func updateEmail(service: String, oldEmail: String, newEmail: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: oldEmail as AnyObject,
        ]
        
        let attributes: [String: Any] = [kSecAttrAccount as String: newEmail]
        
        SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    }
    
    func getPassword(service: String, email: String) throws -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: email as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let _ = SecItemCopyMatching(query as CFDictionary, &result)
        
        return result as? Data
    }
}
