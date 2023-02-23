//
//  SignUpPresenter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//  
//

import Foundation

class SignUpPresenter: ViewToPresenterSignUpProtocol {
    // MARK: Properties
    weak var view: PresenterToViewSignUpProtocol?
    var interactor: PresenterToInteractorSignUpProtocol?
    var router: PresenterToRouterSignUpProtocol?
    
    // MARK: Functions
    
    func emailDidChange(to email: String) {
        interactor?.validateEmail(email)
    }
    
    func passDidChange(to password: String) {
        interactor?.validatePassword(password)
    }
    
    func confirmPassDidChange(to confirmPassword: String, password: String) {
        interactor?.validateConfirmPassword(password, confirmPassword)
    }
    
    func signUpTapped(email: String, password: String) {
        interactor?.signUp(email: email, password: password)
    }
    
    func exit() {
        router?.goBackToSignIn(view!)
    }
}

extension SignUpPresenter: InteractorToPresenterSignUpProtocol {
    func signUpSuccess() {
        router?.showAlert(on: view!, title: "Удачно", message: "Регистрация прошла успешно", handler: { _ in
            self.view?.signUpSuccess()
            self.exit()
        })
    }
    
    func signUpFailure(error: Error) {
        router?.showAlert(on: view!, title: "Ошибка", message: error.localizedDescription, handler: { _ in
            self.view?.signUpFailed()
        })
    }
    
    func fetchValidEmail(_ bool: Bool) {
        view?.updateEmailValidation(isEmailValid: bool)
    }
    
    func fetchValidPasswrod(_ bool: Bool) {
        view?.updatePasswordValidation(isPassValid: bool)
    }
    
    func fetchValidConfirmPassword(_ bool: Bool) {
        view?.updateConfirmPasswordValidation(isConfirmPassValid: bool)
    }
    
    
}
