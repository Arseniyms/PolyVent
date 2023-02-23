//
//  SignInInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//  
//

import Foundation
import Firebase

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
        
        FirebaseService.shared.signIn(email: email, password: password) { result in
            switch result {
            case .success(let success):
                switch success {
                case .OK:
                    self.loginWithUser(email: email)
                default:
                    self.presenter?.signInFailure(error: AuthorizationError.unknownError)
                }
            case .failure(let failure):
                self.presenter?.signInFailure(error: failure)
            }

        }
    }
    
    private func loginWithUser(email: String) {
//        Auth.auth().addStateDidChangeListener { auth, user in
//            if user != nil {
//
//            }
//        }
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
