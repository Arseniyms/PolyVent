//
//  EditProfileInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 05.11.2022.
//
//

import Firebase
import Foundation

class EditProfileInteractor: PresenterToInteractorEditProfileProtocol {
    // MARK: Properties
    var groups: [String]?

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
        if let age = Int(age), age > 0, age <= 120 {
            presenter?.fetchValidAge(true)
        } else {
            presenter?.fetchValidAge(false)
        }
    }

    func getUser() {
        let loggedUser = Auth.auth().currentUser
        let predicate = NSPredicate(format: "id = %@", loggedUser?.uid ?? "")
        let user = DataService.shared.getUser(predicate: predicate)
        if let user {
            presenter?.fetchUserInfo(user)
        }
    }

    func loadGroups() {
        FirebaseService.shared.getGroups { result in
            switch result {
            case .success(let success):
                self.groups = success.sorted()
            case .failure(let error):
                self.presenter?.updateUserFailed(with: error)
            }
        }
    }
    
    func numberOfRowsInComponent() -> Int {
        groups?.count ?? 0
    }
    
    func getGroup(in row: Int) -> String {
        groups?[row] ?? ""
    }
    
    func updateUserInfo(email: String, name: String, lastname: String, age: Int?, group: String) {
        guard let loggedId = Auth.auth().currentUser?.uid else {
            self.presenter?.updateUserFailed(with: AuthorizationError.idError)
            return
        }

        FirebaseService.shared.updateUserInfo(id: loggedId,
                                              email: email,
                                              first_name: name,
                                              last_name: lastname,
                                              age: age ?? 0,
                                              group: group
        ) { result in
            switch result {
            case let .success(success):
                switch success {
                case .OK:
                    do {
                        try DataService.shared.updateUser(id: loggedId, email: email, name: name, lastname: lastname, age: age, group: group)
                        try DataService.shared.saveContext()
                        Thread.sleep(forTimeInterval: 1)
                        self.presenter?.updateUserSuccess()
                    } catch {
                        self.presenter?.updateUserFailed(with: error)
                        return
                    }

                default:
                    self.presenter?.updateUserFailed(with: NetworkErrors.serverError)
                    return
                }
            case let .failure(error):
                self.presenter?.updateUserFailed(with: error)
                return
            }
        }
    }
}
