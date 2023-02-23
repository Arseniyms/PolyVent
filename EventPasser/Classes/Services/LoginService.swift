//
//  LoginService.swift
//  EventPasser
//
//  Created by Arseniy Matus on 15.11.2022.
//

import Foundation

struct LoginService {
    private init() {
        
    }
    
    static var shared: LoginService { LoginService() }
    
    
    func saveLoggedUser(id: UUID) {
        UserDefaults.standard.set("\(id)", forKey: Constants.loginService)
    }
    
    func getLoggedUser() -> UUID? {
        if let str = UserDefaults.standard.string(forKey: Constants.loginService) {
            return UUID(uuidString: str)
        }
        return nil
    }
    
    func deleteLoggedUser() {
        UserDefaults.standard.removeObject(forKey: Constants.loginService)
    }
}
