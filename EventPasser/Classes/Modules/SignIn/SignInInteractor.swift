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
                self.loginWithUser(id: success, email: email)
            case .failure(let failure):
                self.presenter?.signInFailure(error: failure)
            }

        }
    }
    
    private func loginWithUser(id: String, email: String) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("User login")
            } else {
                print("User logout")
            }
        }
        self.presenter?.signInSuccess()
    }
    
}
