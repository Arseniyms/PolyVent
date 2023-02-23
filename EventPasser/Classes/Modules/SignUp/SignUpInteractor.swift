//
//  SignUpInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//
//

import CoreData
import UIKit

class SignUpInteractor: PresenterToInteractorSignUpProtocol {
    // MARK: Properties

    weak var presenter: InteractorToPresenterSignUpProtocol?

    private let emailRegex = Constants.emailRegex
    private let passRegex = Constants.passRegex

    // MARK: Functions

    func validateEmail(_ email: String) {
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        presenter?.fetchValidEmail(emailPred.evaluate(with: email))
    }

    func validatePassword(_ pass: String) {
        let passPred = NSPredicate(format: "SELF MATCHES %@", passRegex)
        presenter?.fetchValidPasswrod(passPred.evaluate(with: pass))
    }

    func validateConfirmPassword(_ pass: String, _ confirmPass: String) {
        presenter?.fetchValidConfirmPassword(pass == confirmPass)
    }

    func signUp(email: String, password: String) {
        FirebaseService.shared.registerNewUser(email: email, password: password) { result in
            switch result {
            case .success(let success):
                switch success {
                case .created:
                    self.presenter?.signUpSuccess()
                default:
                    self.presenter?.signUpFailure(error: AuthorizationError.saveError)
                }
            case .failure(let error):
                self.presenter?.signUpFailure(error: error)
            }
        }
    }
}
