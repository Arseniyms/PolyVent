//
//  AddEventInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.11.2022.
//  
//

import Foundation
import Firebase


import UIKit
import CoreData
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
        do {
            guard let login, let password, let confirmPassword else {
                throw EventAuthorizationError.saveError
            }
            try checkEventInfo(name: name, address: address, maxGuestsCount: maxGuestsCount, login: login, password: password, confirmPassword: confirmPassword)
            FirebaseService.shared.createNewEvent(login: login, name: name, address: address, maxGuestsCount: maxGuestsCount, specification: specification, timeEnd: timeEnd, timeStart: timeStart, password: password) { error in
                if let error {
                    self.presenter?.saveEventFailure(with: error, handler: nil)
                }
            }
            try DataService.shared.saveContext()
            self.presenter?.saveEventSuccess()
//            let event = try DataService.shared.saveEvent(
//                                             login: login,
//                                             name: name,
//                                             address: address,
//                                             maxGuestsCount: maxGuestsCount,
//                                             specification: specification,
//                                             timeEnd: timeEnd,
//                                             timeStart: timeStart)
            
//            NetworkService.shared.addEvent(event, password: password) { result in
//                switch result {
//                case .success(let success):
//                    switch success {
//                    case .created:
//                        do {
//                            try DataService.shared.saveContext()
//                            self.presenter?.saveEventSuccess()
//                        } catch {
//                            self.presenter?.saveEventFailure(with: error, handler: nil)
//                        }
//                    case .badRequest:
//                        self.presenter?.saveEventFailure(with: NetworkErrors.wrongParameters, handler: nil)
//                    default:
//                        self.presenter?.saveEventFailure(with: NetworkErrors.serverError, handler: nil)
//                    }
//                case .failure(let error):
//                    self.presenter?.saveEventFailure(with: error, handler: nil)
//                }
//            }
        } catch {
            presenter?.saveEventFailure(with: error, handler: nil)
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
        let passPred = NSPredicate(format:"SELF MATCHES %@", Constants.passRegex)
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
