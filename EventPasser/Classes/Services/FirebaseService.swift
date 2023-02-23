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
    
    // MARK: Authentication
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
            if let user = result?.user {
                self.createNewUser(id: user.uid)
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
            if let _ = result?.user {
                completion(.success(.OK))
                return
            }
            completion(.failure(AuthorizationError.unknownError))
        }
    }
    
    // MARK: Users
    
    private func createNewUser(id: String) {
        let db = Firestore.firestore()
        
        let parameters: [String: Any] = [
            "id" : id,
            "first_name": "",
            "last_name": "",
            "age": 0,
            "group": "",
            "is_staff": false,
            "is_teacher": false
        ]
        db.collection(Constants.FireCollections.users).addDocument(data: parameters)
    }
    
    
    // MARK: Events
    
    func createNewEvent(_ event: EventEntity, password: String, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormatter
        let parameters: [String: Any] = [
            "id": event.wrappedStringId,
            "title": event.wrappedTitle,
            "login": event.wrappedLogin,
            "password": password,
            "address": event.wrappedAddress,
            "time_start": formatter.string(from: event.wrappedTimeStart),
            "time_end": formatter.string(from: event.wrappedTimeEnd),
            "max_guest_count": event.wrappedMaxCount,
            "description": event.wrappedSpecification,
        ]
        
        db.collection(Constants.FireCollections.events).addDocument(data: parameters)
    }
    
    // MARK: Tickets
    
    func createTicket(of userId: String, to eventId: UUID) {
        let db = Firestore.firestore()
        
        let parameters: [String: Any] = [
            "id": UUID().uuidString,
            "event_id": eventId.uuidString,
            "user_id": userId,
            "is_inside": false,
        ]
        
        db.collection(Constants.FireCollections.tickets).addDocument(data: parameters)
    }
    
}
