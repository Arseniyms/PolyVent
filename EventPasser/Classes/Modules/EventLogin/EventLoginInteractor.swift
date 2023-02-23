//
//  EventLoginInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 04.12.2022.
//
//

import Foundation

class EventLoginInteractor: PresenterToInteractorEventLoginProtocol {
    // MARK: Properties

    weak var presenter: InteractorToPresenterEventLoginProtocol?

    func signIn(login: String, password: String) {
        let predicate = NSPredicate(format: "login == %@", login)
        let event = DataService.shared.getEvent(predicate: predicate)
        guard let event else {
            self.presenter?.signInFailure(with: AuthorizationError.invalidEmailOrPassword)
            return
        }

        NetworkService.shared.getEventPassword(by: event.wrappedId) { result in
            switch result {
            case let .success(success):
                if password == success {
                    self.presenter?.signInSuccess(with: event)
                    return
                } else {
                    self.presenter?.signInFailure(with: AuthorizationError.invalidEmailOrPassword)
                    return
                }
            case let .failure(error):
                self.presenter?.signInFailure(with: error)
                return
            }
        }
    }
}
