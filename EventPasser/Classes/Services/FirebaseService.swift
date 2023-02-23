//
//  FirebaseService.swift
//  EventPasser
//
//  Created by Arseniy Matus on 23.02.2023.
//

import Foundation
import Firebase

class FirebaseService {
    private init() { }
    
    static var shared: FirebaseService { FirebaseService() }
    
    func registerNewUser(email: String, password: String, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                if error.localizedDescription == "The email address is already in use by another account." {
                    completion(.failure(AuthorizationError.emailAlreadyExist))
                } else {
                    completion(.failure(error))
                }
                return
            }
            if result?.user != nil {
                completion(.success(.created))
                return
            }
            completion(.failure(AuthorizationError.unknownError))
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                if error.localizedDescription == "The password is invalid or the user does not have a password." {
                    completion(.failure(AuthorizationError.invalidEmailOrPassword))
                } else {
                    completion(.failure(error))
                }
                return
            }
            if result?.user != nil {
                completion(.success(.OK))
                return
            }
            completion(.failure(AuthorizationError.unknownError))
        }
    }
}
