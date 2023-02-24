//
//  FirebaseService.swift
//  EventPasser
//
//  Created by Arseniy Matus on 23.02.2023.
//

import Firebase
import UIKit

class FirebaseService {
    private init() { }

    static var shared: FirebaseService { FirebaseService() }

    // MARK: Authentication

    func registerNewUser(email: String, password: String, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                switch error {
                case AuthErrorCode.emailAlreadyInUse:
                    completion(.failure(AuthorizationError.emailAlreadyExist))
                default:
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

    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                switch error {
                case AuthErrorCode.wrongPassword:
                    completion(.failure(AuthorizationError.invalidEmailOrPassword))
                default:
                    completion(.failure(error))
                }
                return
            }
            if let user = result?.user {
                completion(.success(user.uid))
                return
            }
            completion(.failure(AuthorizationError.unknownError))
        }
    }

    // MARK: Users

    private func createNewUser(id: String) {
        let db = Firestore.firestore()

        let parameters: [String: Any] = [
            "id": id,
            "first_name": "",
            "last_name": "",
            "age": 0,
            "group": "",
            "is_staff": false,
            "is_teacher": false,
        ]
        db.collection(Constants.FireCollections.users).addDocument(data: parameters)
    }

    func loadUsersToCoreData(completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        DataService.shared.deleteFromCoreData(entityName: "UserEntity")
        let db = Firestore.firestore()

        db.collection("users").getDocuments { snapshot, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let snapshot else {
                completion(.failure(NetworkErrors.dataError))
                return
            }
            
            let users: [UserEntity] = snapshot.documents.compactMap { doc in
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.context] = DataService.context
                let data = try? JSONSerialization.data(withJSONObject: doc.data())
                let user = try? decoder.decode(UserEntity.self, from: data ?? Data())
                return user
            }

            completion(.success(users))
        }
    }

    // MARK: Events

    func createNewEvent(_ event: EventEntity, password: String, completion: @escaping ((Error) -> Void)) {
        let db = Firestore.firestore()

        let newDocument = db.collection(Constants.FireCollections.events).document()

        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormatter
        let parameters: [String: Any] = [
            "id": newDocument.documentID,
            "title": event.wrappedTitle,
            "login": event.wrappedLogin,
            "password": password,
            "address": event.wrappedAddress,
            "time_start": formatter.string(from: event.wrappedTimeStart),
            "time_end": formatter.string(from: event.wrappedTimeEnd),
            "max_guest_count": event.wrappedMaxCount,
            "description": event.wrappedSpecification,
        ]
        newDocument.setData(parameters) { error in
            if let error {
                completion(error)
            }
        }
    }

    // MARK: Tickets

    func createTicket(of userId: String, to eventId: UUID) {
        let db = Firestore.firestore()

        let parameters: [String: Any] = [
            "event_id": eventId.uuidString,
            "user_id": userId,
            "is_inside": false,
        ]

        db.collection(Constants.FireCollections.tickets).addDocument(data: parameters)
    }
}
