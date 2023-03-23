//
//  AddEventInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.11.2022.
//
//

import Firebase
import UIKit

class AddEventInteractor: PresenterToInteractorAddEventProtocol {
    // MARK: Properties

    weak var presenter: InteractorToPresenterAddEventProtocol?

    func isUserStaff() {
        let loggedId = Auth.auth().currentUser?.uid ?? ""
        let predicate = NSPredicate(format: "id = %@", loggedId)
        let user = DataService.shared.getUser(predicate: predicate)

        if !(user?.is_staff ?? false) {
            presenter?.saveEventFailure(with: AuthorizationError.userNotStaff, handler: { _ in
                self.presenter?.saveEventSuccess()
            })
        }
    }

    func saveEvent(name: String, address: String, maxGuestsCount: Int, specification: String, timeEnd: Date, timeStart: Date, login: String?, password: String?, confirmPassword: String?) {
        guard let login, let password, let confirmPassword else {
            presenter?.saveEventFailure(with: EventAuthorizationError.invalidLogin, handler: nil)
            return
        }
        do {
            try checkEventInfo(name: name, address: address, maxGuestsCount: maxGuestsCount, login: login, password: password, confirmPassword: confirmPassword)
        } catch {
            presenter?.saveEventFailure(with: error, handler: nil)
            return
        }

        FirebaseService.shared.createNewEvent(login: login,
                                              name: name,
                                              address: address,
                                              maxGuestsCount: maxGuestsCount,
                                              specification: specification,
                                              timeEnd: timeEnd,
                                              timeStart: timeStart,
                                              password: password)
        { error in
            if let error {
                self.presenter?.saveEventFailure(with: error, handler: nil)
            } else {
                try? DataService.shared.saveContext()
                self.presenter?.saveEventSuccess()
            }
        }
    }

    func checkEventInfo(name: String, address: String, maxGuestsCount: Int, login: String, password: String, confirmPassword: String) throws {
        try checkName(name)
        try checkAddress(address)
        try checkGuestCount(maxGuestsCount)
        try checkLogin(login)
        try checkPassword(password)
        try checkConfirmPassword(confirmPassword, with: password)
    }

    private func checkName(_ name: String) throws {
        if name.isEmpty || name.count > Constants.maxInfoLenght {
            throw EventAuthorizationError.invalidName
        }
    }

    private func checkAddress(_ address: String) throws {
        if address.isEmpty || address.count > Constants.maxInfoLenght {
            throw EventAuthorizationError.invalidAddress
        }
    }

    private func checkGuestCount(_ count: Int) throws {
        if count < Constants.minGuestsCount || count > Constants.maxGuestsCount {
            throw EventAuthorizationError.invalidGuestCount
        }
    }

    private func checkLogin(_ login: String) throws {
        if login.isEmpty || login.count > Constants.maxInfoLenght {
            throw EventAuthorizationError.invalidLogin
        }
    }

    private func checkPassword(_ pass: String) throws {
        let passPred = NSPredicate(format: "SELF MATCHES %@", Constants.passRegex)
        if !passPred.evaluate(with: pass) || pass.isEmpty {
            throw EventAuthorizationError.invalidPassword
        }
    }

    private func checkConfirmPassword(_ confirmPass: String, with pass: String) throws {
        if confirmPass != pass {
            throw EventAuthorizationError.invalidConfirmPassword
        }
    }
}
