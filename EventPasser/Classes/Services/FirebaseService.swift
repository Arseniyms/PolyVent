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
                case AuthErrorCode.wrongPassword, AuthErrorCode.userNotFound:
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

        let parameters: [String: Any?] = [
            "id": id,
            "first_name": nil,
            "last_name": nil,
            "age": 0,
            "group": "",
            "is_staff": false,
            "is_teacher": false,
        ]
        db.collection(Constants.FireCollections.users).document(id).setData(parameters as [String: Any])
    }

    func updateUserInfo(id: String, email: String, first_name: String, last_name: String, age: Int, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection(Constants.FireCollections.users).document(id).updateData([
            "first_name": first_name,
            "last_name": last_name,
            "age": age,
        ]) { error in
            if let error {
                print(error)
                completion(.failure(NetworkErrors.wrongParameters))
                return
            }
        }
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            if error != nil {
                completion(.failure(AuthorizationError.emailAlreadyExist))
                return
            }
        }

        completion(.success(.OK))
    }

    func loadUsersToCoreData(completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        DataService.shared.deleteFromCoreData(entityName: Constants.CoreDataEntities.userEntityName)
        let db = Firestore.firestore()

        db.collection("users").getDocuments { snapshot, error in
            if let error {
                return completion(.failure(error))
            }

            guard let snapshot else {
                return completion(.failure(NetworkErrors.dataError))
            }

            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context] = DataService.context

            let users: [UserEntity] = snapshot.documents.compactMap { doc in
                let data = try? JSONSerialization.data(withJSONObject: doc.data())
                let user = try? decoder.decode(UserEntity.self, from: data ?? Data())
                return user
            }
            completion(.success(users))
        }
    }

    // MARK: Events

    func loadEventsToCoreData(completion: @escaping (Result<[EventEntity], Error>) -> Void) {
        DataService.shared.deleteFromCoreData(entityName: Constants.CoreDataEntities.eventEntityName)
        let db = Firestore.firestore()

        db.collection("events").getDocuments { snapshot, error in
            if let error {
                return completion(.failure(error))
            }

            guard let snapshot else {
                return completion(.failure(NetworkErrors.dataError))
            }

            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context] = DataService.context

            let events: [EventEntity] = snapshot.documents.compactMap { doc in
                let data = try? JSONSerialization.data(withJSONObject: doc.data())
                let event = try? decoder.decode(EventEntity.self, from: data ?? Data())
                return event
            }

            self.loadTicketsToCoreData { result in
                switch result {
                case .success:
                    completion(.success(events))
                case let .failure(failure):
                    completion(.failure(failure))
                }
            }
        }
    }

    func createNewEvent(login: String?, name: String, address: String, maxGuestsCount: Int, specification: String, timeEnd: Date, timeStart: Date, password: String, completion: @escaping ((Error?) -> Void)) {
        let db = Firestore.firestore()

        guard let login else {
            return completion(EventAuthorizationError.invalidLogin)
        }

        let query = db.collection(Constants.FireCollections.events).whereField("login", isEqualTo: login as String)
        query.getDocuments { snapshot, error in
            if let error {
                return completion(error)
            }
            if !(snapshot?.isEmpty ?? false) {
                return completion(EventAuthorizationError.eventAlreadyExist)
            } else {
                let newDocument = db.collection(Constants.FireCollections.events).document()

                let id = newDocument.documentID

                do {
                    let event = try DataService.shared.saveEvent(id: id,
                                                                 login: login,
                                                                 name: name,
                                                                 address: address,
                                                                 maxGuestsCount: maxGuestsCount,
                                                                 specification: specification,
                                                                 timeEnd: timeEnd,
                                                                 timeStart: timeStart)

                    let formatter = DateFormatter()
                    formatter.dateFormat = Constants.dateFormatter
                    let parameters: [String: Any] = [
                        "id": id,
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
                            return completion(error)
                        }
                    }
                } catch {
                    return completion(error)
                }

                completion(nil)
            }
        }
    }

    // MARK: Tickets

    func createTicket(of userId: String, to eventId: String, completion: @escaping (Error?) -> Void) {
        loadEventsToCoreData { result in
            switch result {
            case .success:
                let event = DataService.shared.getEvent(predicate: NSPredicate(format: "id = %@", eventId))
                if event?.isFull ?? true {
                    return completion(TicketErrors.notEnoughSpace)
                }
                let db = Firestore.firestore()
                
                let newDocument = db.collection(Constants.FireCollections.tickets).document()
                
                let parameters: [String: Any] = [
                    "id": newDocument.documentID,
                    "event_id": eventId,
                    "user_id": userId,
                    "is_inside": false,
                ]
                
                newDocument.setData(parameters) { error in
                    if let error {
                        return completion(error)
                    }
                    completion(nil)
                }
                
            case .failure(let error):
                return completion(error)
            }
        }
    }
    
    func deleteTicket(of userId: String, to eventId: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        let ticketId = (try? DataService.shared.getTicketID(of: userId, to: eventId)) ?? ""
        
        let docRef = db.collection(Constants.FireCollections.tickets).document(ticketId)
        
        docRef.delete { error in
            if let error {
                return completion(error)
            }
            completion(nil)
        }
    }

    func loadTicketsToCoreData(completion: @escaping (Result<[TicketEntity], Error>) -> Void) {
        DataService.shared.deleteFromCoreData(entityName: Constants.CoreDataEntities.ticketEntityName)
        let db = Firestore.firestore()

        db.collection(Constants.FireCollections.tickets).getDocuments { snapshot, error in
            if let error {
                return completion(.failure(error))
            }

            guard let snapshot else {
                return completion(.failure(NetworkErrors.dataError))
            }

            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context] = DataService.context

            let tickets: [TicketEntity] = snapshot.documents.compactMap { doc in
                let data = try? JSONSerialization.data(withJSONObject: doc.data())
                let ticket = try? decoder.decode(TicketEntity.self, from: data ?? Data())
                return ticket
            }

            completion(.success(tickets))
        }
    }
    
    
    func getEventPassword(by id: String, completion: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
        
        let docRef = db.collection(Constants.FireCollections.events).document(id)
        
        docRef.getDocument { document, error in
            if let error {
                return completion(.failure(error))
            }
            if let document, document.exists {
                let data = document.data()
                if let password = data?["password"] as? String {
                    return completion(.success(password))
                }
            }
            completion(.failure(EventAuthorizationError.invalidLogin))
        }
    }
}
