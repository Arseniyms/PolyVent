//
//  SignUpContract.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//  
//

import UIKit


// MARK: View Output (Presenter -> View)
protocol PresenterToViewSignUpProtocol: AnyObject {
    func updatePasswordValidation(isPassValid: Bool)
    func updateConfirmPasswordValidation(isConfirmPassValid: Bool)
    func updateEmailValidation(isEmailValid: Bool)
    
    func signUpSuccess()
    func signUpFailed()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterSignUpProtocol: AnyObject {
    
    var view: PresenterToViewSignUpProtocol? { get set }
    var interactor: PresenterToInteractorSignUpProtocol? { get set }
    var router: PresenterToRouterSignUpProtocol? { get set }
    
    func emailDidChange(to email: String)
    func passDidChange(to password: String)
    func confirmPassDidChange(to confirmPassword: String, password: String)
    
    func signUpTapped(email: String, password: String)
    func exit()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSignUpProtocol: AnyObject {
    
    var presenter: InteractorToPresenterSignUpProtocol? { get set }
    
    func validateEmail(_ email: String)
    func validatePassword(_ pass: String)
    func validateConfirmPassword(_ pass: String, _ confirmPass: String)
    
    func signUp(email: String, password: String)
    
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSignUpProtocol: AnyObject {
    func fetchValidEmail(_ bool: Bool)
    func fetchValidPasswrod(_ bool: Bool)
    func fetchValidConfirmPassword(_ bool: Bool)
    
    func signUpSuccess()
    func signUpFailure(error: Error)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterSignUpProtocol: AnyObject {
    func goBackToSignIn(_ view: PresenterToViewSignUpProtocol)
    
    func showAlert(on view: PresenterToViewSignUpProtocol, title: String, message: String, handler: ((UIAlertAction) -> ())?)
}
