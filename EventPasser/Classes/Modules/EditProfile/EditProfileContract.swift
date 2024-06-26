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
    func updateSelectedGroup(with group: String)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterEditProfileProtocol: NSObject, AnyObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var view: PresenterToViewEditProfileProtocol? { get set }
    var interactor: PresenterToInteractorEditProfileProtocol? { get set }
    var router: PresenterToRouterEditProfileProtocol? { get set }
    
    func emailDidChange(_ email: String)
    func nameDidChange(_ name: String)
    func lastNameDidChange(_ lastName: String)
    func ageDidChange(_ age: String)
    
    func viewDidLoad()
    func save(email: String?, name: String?, lastname: String?, age: String?, group: String?)
    func deleteAccount()
    func updatePresentingViewController(_ vc: UIViewController?)
    func exit()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorEditProfileProtocol: AnyObject {
    
    var presenter: InteractorToPresenterEditProfileProtocol? { get set }
    
    var groups: [String]? { get set }
    
    func validateEmail(_ email: String)
    func validateName(_ name: String)
    func validateLastName(_ lastName: String)
    func validateAge(_ age: String)
    
    func getUser()
    func loadGroups()
    func updateUserInfo(email: String, name: String, lastname: String, age: Int?, group: String)
    func deleteAccount()
    
    func numberOfRowsInComponent() -> Int
    func getGroup(in row: Int) -> String
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterEditProfileProtocol: AnyObject {
    func fetchValidEmail(_ bool: Bool)
    func fetchValidName(_ bool: Bool)
    func fetchValidLastName(_ bool: Bool)
    func fetchValidAge(_ bool: Bool)
    
    func fetchUserInfo(_ user: UserEntity)
    
    func goToSignIn()

    func updateUserSuccess()
    func updateUserFailed(with error: Error)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterEditProfileProtocol: AnyObject {
    func dismissEditProfile(_ view: PresenterToViewEditProfileProtocol)
    func saveEditProfile(_ view: PresenterToViewEditProfileProtocol)
    func showErrorAlert(on view: PresenterToViewEditProfileProtocol, title: String, message: String)
    func showDeleteAlert(on view: PresenterToViewEditProfileProtocol, handler: ((UIAlertAction) -> Void)?)
    func exitApp(on view: PresenterToViewEditProfileProtocol)
}
