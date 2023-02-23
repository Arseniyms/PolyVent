//
//  EditProfileMockPresenter.swift
//  EventPasserTests
//
//  Created by Arseniy Matus on 21.12.2022.
//

import Foundation

@testable
import EventPasser

class EditProfileMockPresenter: InteractorToPresenterEditProfileProtocol {
    private(set) var isEmailValid = false
    private(set) var isNameValid = false
    private(set) var isLastNameValid = false
    private(set) var isAgeValid = false

    
    func fetchValidEmail(_ bool: Bool) {
        isEmailValid = bool
    }
    
    func fetchValidName(_ bool: Bool) {
        isNameValid = bool
    }
    
    func fetchValidLastName(_ bool: Bool) {
        isLastNameValid = bool
    }
    
    func fetchValidAge(_ bool: Bool) {
        isAgeValid = bool
    }
    
    func fetchUserInfo(_ user: EventPasser.UserEntity) {
        return
    }
    
    func updateUserSuccess() {
        return
    }
    
    func updateUserFailed(with error: Error) {
        return
    }
    
}
