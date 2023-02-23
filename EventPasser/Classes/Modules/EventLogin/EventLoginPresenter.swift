//
//  EventLoginPresenter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 04.12.2022.
//  
//

import Foundation

class EventLoginPresenter: ViewToPresenterEventLoginProtocol {
    // MARK: Properties
    weak var view: PresenterToViewEventLoginProtocol?
    var interactor: PresenterToInteractorEventLoginProtocol?
    var router: PresenterToRouterEventLoginProtocol?
    
    func signInTapped(login: String, password: String) {
        interactor?.signIn(login: login, password: password)
    }
}

extension EventLoginPresenter: InteractorToPresenterEventLoginProtocol {
    func signInSuccess(with event: EventEntity) {
        router?.pushEventDescription(on: view!, with: event)
    }
    
    func signInFailure(with error: Error) {
        router?.presentErrorAlert(on: view!, title: "Ошибка", message: error.localizedDescription) { _ in
            self.view?.loginFailed()
        }
    }
    
    
}
