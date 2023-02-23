//
//  SignUpMockPresenter.swift
//  EventPasserTests
//
//  Created by Arseniy Matus on 21.12.2022.
//

import Foundation

@testable
import EventPasser

class SignUpMockPresenter: InteractorToPresenterSignUpProtocol {
    private(set) var isEmailValid = false
    private(set) var isPasswordValid = false
    private(set) var isConfirmPasswordValid = false

    func fetchValidEmail(_ bool: Bool) {
        isEmailValid = bool
    }
    
    func fetchValidPasswrod(_ bool: Bool) {
        isPasswordValid = bool
    }
    
    func fetchValidConfirmPassword(_ bool: Bool) {
        isConfirmPasswordValid = bool
    }
    
    func signUpSuccess() {
        return
    }
    
    func signUpFailure(error: Error) {
        return
    }
    
}
