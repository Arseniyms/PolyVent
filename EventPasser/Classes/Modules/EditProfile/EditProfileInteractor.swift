//
//  EditProfileInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 05.11.2022.
//
//

import Foundation

class EditProfileInteractor: PresenterToInteractorEditProfileProtocol {
    // MARK: Properties

    let emailRegex = Constants.emailRegex

    weak var presenter: InteractorToPresenterEditProfileProtocol?

    func validateEmail(_ email: String) {
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        presenter?.fetchValidEmail(emailPred.evaluate(with: email))
    }

    func validateName(_ name: String) {
        let numbersRange = name.rangeOfCharacter(from: .decimalDigits)
        let hasNumbers = (numbersRange != nil)
        presenter?.fetchValidName(!name.isEmpty && !hasNumbers)
    }

    func validateLastName(_ lastName: String) {
        let numbersRange = lastName.rangeOfCharacter(from: .decimalDigits)
        let hasNumbers = (numbersRange != nil)
        presenter?.fetchValidLastName(!lastName.isEmpty && !hasNumbers)
    }

    func validateAge(_ age: String) {
        if let age = Int(age), age > 0 {
            presenter?.fetchValidAge(true)
        } else {
            presenter?.fetchValidAge(false)
        }
    }

    func getUser() {
        let loggedId = LoginService.shared.getLoggedUser() ?? UUID()
        let predicate = NSPredicate(format: "id = %@", loggedId as CVarArg)
        let user = DataService.shared.getUser(predicate: predicate)

        if let user {
            presenter?.fetchUserInfo(user)
        }
    }

    func updateUserInfo(email: String, name: String, lastname: String, age: Int?) {
        guard let loggedId = LoginService.shared.getLoggedUser() else {
            self.presenter?.updateUserFailed(with: AuthorizationError.idError)
            return
        }

        NetworkService.shared.updateUserInfo(id: loggedId, email: email, name: name, last_name: lastname, age: age ?? 0) { result in
            switch result {
            case let .success(success):
                switch success {
                case .OK:
                    do {
                        try DataService.shared.updateUser(id: loggedId, email: email, name: name, lastname: lastname, age: age)
                        try DataService.shared.saveContext()
                        self.presenter?.updateUserSuccess()
                    } catch {
                        self.presenter?.updateUserFailed(with: error)
                    }
                case .badRequest:
                    self.presenter?.updateUserFailed(with: AuthorizationError.emailAlreadyExist)
                default:
                    self.presenter?.updateUserFailed(with: NetworkErrors.serverError)
                }
            case let .failure(error):
                self.presenter?.updateUserFailed(with: error)
            }
        }
    }
}
