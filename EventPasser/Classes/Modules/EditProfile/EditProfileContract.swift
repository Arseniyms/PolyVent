//
//  EditProfileContract.swift
//  EventPasser
//
//  Created by Arseniy Matus on 05.11.2022.
//  
//

import UIKit


// MARK: View Output (Presenter -> View)
protocol PresenterToViewEditProfileProtocol: AnyObject {
    func updateEmailValidation(isEmailValid: Bool)
    func updateNameValidation(isNameValid: Bool)
    func updateLastNameValidation(isLastNameValid: Bool)
    func updateAgeValidation(isAgeValid: Bool)

    func updateUserInfo(_ user: UserEntity)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterEditProfileProtocol: AnyObject {
    var view: PresenterToViewEditProfileProtocol? { get set }
    var interactor: PresenterToInteractorEditProfileProtocol? { get set }
    var router: PresenterToRouterEditProfileProtocol? { get set }
    
    func emailDidChange(_ email: String)
    func nameDidChange(_ name: String)
    func lastNameDidChange(_ lastName: String)
    func ageDidChange(_ age: String)
    
    func viewDidLoad()
    func save(email: String?, name: String?, lastname: String?, age: String?)
    func updatePresentingViewController(_ vc: UIViewController?)
    func exit()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorEditProfileProtocol: AnyObject {
    
    var presenter: InteractorToPresenterEditProfileProtocol? { get set }
    
    func validateEmail(_ email: String)
    func validateName(_ name: String)
    func validateLastName(_ lastName: String)
    func validateAge(_ age: String)
    
    func getUser()
    func loadGroups()
    func updateUserInfo(email: String, name: String, lastname: String, age: Int?)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterEditProfileProtocol: AnyObject {
    func fetchValidEmail(_ bool: Bool)
    func fetchValidName(_ bool: Bool)
    func fetchValidLastName(_ bool: Bool)
    func fetchValidAge(_ bool: Bool)
    
    func fetchUserInfo(_ user: UserEntity)
    
    
    func updateUserSuccess()
    func updateUserFailed(with error: Error)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterEditProfileProtocol: AnyObject {
    func dismissEditProfile(_ view: PresenterToViewEditProfileProtocol)
    func saveEditProfile(_ view: PresenterToViewEditProfileProtocol)
    func showErrorAlert(on view: PresenterToViewEditProfileProtocol, title: String, message: String)
}
