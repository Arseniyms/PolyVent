//
//  NetworkService.swift
//  EventPasser
//
//  Created by Arseniy Matus on 22.12.2022.
//

import UIKit

@available(*, deprecated, message: "Используйте FireBaseService")
class NetworkService {
    private init() { }

    static var shared: NetworkService { NetworkService() }

    // MARK: GET Requests

    func loadUsersToCoreData(completion: @escaping (Result<[UserEntity], Error>) -> Void) {
        guard let url = URL(string: Constants.NetworkURL.baseURL + "/users") else {
            completion(.failure(NetworkErrors.wrongBaseURL))
            return
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 3
        config.timeoutIntervalForResource = 3
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(error))
                    return
                }

                guard let data else {
                    completion(.failure(NetworkErrors.dataError))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context] = DataService.context
                    DataService.shared.deleteFromCoreData(entityName: "UserEntity")
                    let results = try decoder.decode([UserEntity].self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func loadEventsToCoreData(completion: @escaping (Result<[EventEntity], Error>) -> Void) {
        guard let url = URL(string: Constants.NetworkURL.baseURL + "/events") else {
            completion(.failure(NetworkErrors.wrongBaseURL))
            return
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 3
        config.timeoutIntervalForResource = 3
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let _ = error {
                    completion(.failure(NetworkErrors.serverError))
                    return
                }

                guard let data else {
                    completion(.failure(NetworkErrors.dataError))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context] = DataService.context
                    DataService.shared.deleteFromCoreData(entityName: Constants.CoreDataEntities.eventEntityName)
                    let results = try decoder.decode([EventEntity].self, from: data)
                    self.loadTicketsToCoreData(completion: { result in
                        switch result {
                        case .success:
                            completion(.success(results))
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    })

                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func loadTicketsToCoreData(completion: @escaping (Result<[TicketEntity], Error>) -> Void) {
        guard let url = URL(string: Constants.NetworkURL.baseURL + "/tickets") else {
            completion(.failure(NetworkErrors.wrongBaseURL))
            return
        }

        loadUsersToCoreData { result in
            switch result {
            case .success:
                let config = URLSessionConfiguration.default
                config.timeoutIntervalForRequest = 3
                config.timeoutIntervalForResource = 3
                let session = URLSession(configuration: config)
                
                session.dataTask(with: url) { data, _, error in
                    DispatchQueue.main.async {
                        if let _ = error {
                            completion(.failure(NetworkErrors.serverError))
                            return
                        }

                        guard let data else {
                            completion(.failure(NetworkErrors.dataError))
                            return
                        }

                        do {
                            let decoder = JSONDecoder()
                            decoder.userInfo[CodingUserInfoKey.context] = DataService.context
                            DataService.shared.deleteFromCoreData(entityName: Constants.CoreDataEntities.ticketEntityName)
                            let results = try decoder.decode([TicketEntity].self, from: data)

                            completion(.success(results))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }.resume()
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getEventPassword(by id: UUID, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: Constants.NetworkURL.baseURL + "/events/\(id.uuidString)") else {
            completion(.failure(NetworkErrors.wrongBaseURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let _ = error {
                    completion(.failure(NetworkErrors.serverError))
                    return
                }

                guard let data else {
                    completion(.failure(NetworkErrors.dataError))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    if let password = json?["password"] as? String {
                        completion(.success(password))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    // MARK: POST Requests

    func setTicket(user: UUID, event: UUID, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        let parameters: [String: Any] = [
            "id": UUID().uuidString,
            "event_id": event.uuidString,
            "user_id": user.uuidString,
            "is_inside": false,
        ]

        do {
            let request = try prepareRequest(urlString: Constants.NetworkURL.baseURL + "/tickets/", parameters: parameters, httpMethod: "POST")

            requestWithResponse(request, completion: completion)

        } catch {
            completion(.failure(error))
        }
    }

    func addEvent(_ event: EventEntity, password: String, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormatter

        let parameters: [String: Any] = [
            "id": event.wrappedId,
            "title": event.wrappedTitle,
            "login": event.wrappedLogin,
            "password": password,
            "address": event.wrappedAddress,
            "time_start": formatter.string(from: event.wrappedTimeStart),
            "time_end": formatter.string(from: event.wrappedTimeEnd),
            "max_guest_count": event.wrappedMaxCount,
            "description": event.wrappedSpecification,
        ]

        do {
            let request = try prepareRequest(urlString: Constants.NetworkURL.baseURL + "/events/", parameters: parameters, httpMethod: "POST")

            requestWithResponse(request, completion: completion)

        } catch {
            completion(.failure(error))
        }
    }

    func registerNewUser(id: UUID, email: String, password: String, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        let parameters = [
            "id": id.uuidString,
            "email": email,
            "password": password,
        ]

        do {
            let request = try prepareRequest(urlString: Constants.NetworkURL.baseURL + "/auth/register", parameters: parameters, httpMethod: "POST")

            requestWithResponse(request, completion: completion)

        } catch {
            completion(.failure(error))
        }
    }

    func signIn(username: String, password: String, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        let parameters = [
            "username": username,
            "password": password,
        ]

        do {
            let request = try prepareRequest(urlString: Constants.NetworkURL.baseURL + "/auth/login", parameters: parameters, httpMethod: "POST")

            requestWithResponse(request, completion: completion)

        } catch {
            completion(.failure(error))
        }
    }

    // MARK: PATCH Requests

    func updateUserInfo(id: UUID, email: String, name: String, last_name: String, age: Int, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        let parameters: [String: Any] = [
            "first_name": name,
            "last_name": last_name,
            "age": age,
            "username": email,
        ]

        do {
            let request = try prepareRequest(urlString: Constants.NetworkURL.baseURL + "/users/\(id.uuidString)/", parameters: parameters, httpMethod: "PATCH")
            requestWithResponse(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    func userGoInside(_ user: UserEntity, on event: EventEntity, isInside: Bool, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        var id = ""
        do {
            id = try DataService.shared.getTicket(of: user, to: event).id ?? ""
        } catch {
            completion(.failure(error))
            return
        }

        let parameters: [String: Any] = [
            "is_inside": isInside,
        ]

        do {
            let request = try prepareRequest(urlString: Constants.NetworkURL.baseURL + "/tickets/\(id)/", parameters: parameters, httpMethod: "PATCH")
            requestWithResponse(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: DELETE Requests

    func deleteTicket(of user: UUID, to event: UUID, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        guard let ticketId = try? DataService.shared.getTicketID(of: user.uuidString, to: event.uuidString) else {
            completion(.failure(NetworkErrors.wrongParameters))
            return
        }

        guard let url = URL(string: Constants.NetworkURL.baseURL + "/tickets/\(ticketId)") else {
            completion(.failure(NetworkErrors.wrongBaseURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        requestWithResponse(request, completion: completion)
    }

    // MARK: Prepare functions

    private func prepareRequest(urlString: String, parameters: [String: Any], httpMethod: String) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw (NetworkErrors.wrongBaseURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted, .fragmentsAllowed])
        } catch {
            throw NetworkErrors.wrongParameters
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }

    private func requestWithResponse(_ request: URLRequest, completion: @escaping (Result<ResponseStatus, Error>) -> Void) {
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(NetworkErrors.serverError))
                    return
                }

                guard data != nil else {
                    completion(.failure(NetworkErrors.dataError))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    completion(.success(httpResponse.status))
                }
            }
        }).resume()
    }
}
