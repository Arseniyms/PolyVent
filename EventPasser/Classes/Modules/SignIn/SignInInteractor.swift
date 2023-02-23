//
//  SignInInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//  
//

import Foundation

class SignInInteractor: PresenterToInteractorSignInProtocol {
    // MARK: Properties
    weak var presenter: InteractorToPresenterSignInProtocol?
        
    func validateEmail(_ email: String) {
        presenter?.fetchValidEmail(email.count > 0)
    }
    
    func validatePassword(_ pass: String) {
        presenter?.fetchValidPasswrod(pass.count > 0)
    }
    
    func signIn(email: String, password: String) {
        
        NetworkService.shared.signIn(username: email, password: password) { [weak self] result in
            guard let self else {
                self?.presenter?.signInFailure(error: NetworkErrors.serverError)
                return
            }
            switch result {
            case .success(let success):
                switch success {
                case .OK:
                    self.loginWithUser(email: email)
                case .unathorized:
                    self.presenter?.signInFailure(error: AuthorizationError.invalidEmailOrPassword)
                case .badRequest:
                    self.presenter?.signInFailure(error: AuthorizationError.blankField)
                case .serverError:
                    self.presenter?.signInFailure(error: NetworkErrors.serverError)
                default:
                    self.presenter?.signInFailure(error: AuthorizationError.unknownError)
                }
            case .failure(let error):
                self.presenter?.signInFailure(error: error)
            }
        }
    }
    
    private func loginWithUser(email: String) {
        NetworkService.shared.loadUsersToCoreData { result in
            switch result {
            case .success(let success):
                guard let user = success.first(where: { $0.email == email }) else {
                    self.presenter?.signInFailure(error: NetworkErrors.wrongParameters)
                    return
                }
                LoginService.shared.saveLoggedUser(id: user.wrappedId)
                self.presenter?.signInSuccess()
            case .failure(let error):
                self.presenter?.signInFailure(error: error)
            }
        }
    }
    
}
