//
//  SignInPresenter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//  
//

import Foundation

class SignInPresenter: ViewToPresenterSignInProtocol {
    // MARK: Properties
    weak var view: PresenterToViewSignInProtocol?
    var interactor: PresenterToInteractorSignInProtocol?
    var router: PresenterToRouterSignInProtocol?
    
    func emailDidChange(to email: String) {
        interactor?.validateEmail(email)
    }
    
    func passDidChange(to password: String) {
        interactor?.validatePassword(password)
    }
    
    func goToSignUp() {
        router?.pushToSignUpController(on: view!)
    }
    
    func signInTapped(email: String, password: String) {
        interactor?.signIn(email: email, password: password)
    }
    
}

extension SignInPresenter: InteractorToPresenterSignInProtocol {
    func signInSuccess() {
        router?.pushToMainController(on: view!)
    }
    
    func signInFailure(error: Error) {
        router?.showErrorAlert(on: view!, title: "Ошибка", message: error.localizedDescription, handler: { _ in
            self.view?.signInFailed()
        })
    }
    
    func fetchValidPasswrod(_ bool: Bool) {
        view?.updatePasswordValidation(isPassValid: bool)
    }
    
    func fetchValidEmail(_ bool: Bool) {
        view?.updateEmailValidation(isEmailValid: bool)
    }
}
