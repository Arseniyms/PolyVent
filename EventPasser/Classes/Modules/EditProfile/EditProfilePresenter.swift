//
//  EditProfilePresenter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 05.11.2022.
//
//

import UIKit

class EditProfilePresenter: ViewToPresenterEditProfileProtocol {
    // MARK: Properties

    weak var view: PresenterToViewEditProfileProtocol?
    var interactor: PresenterToInteractorEditProfileProtocol?
    var router: PresenterToRouterEditProfileProtocol?

    func emailDidChange(_ email: String) {
        interactor?.validateEmail(email)
    }

    func nameDidChange(_ name: String) {
        interactor?.validateName(name)
    }

    func lastNameDidChange(_ lastName: String) {
        interactor?.validateLastName(lastName)
    }

    func ageDidChange(_ age: String) {
        interactor?.validateAge(age)
    }

    func viewDidLoad() {
        interactor?.getUser()
        interactor?.loadGroups()
    }

    func save(email: String?, name: String?, lastname: String?, age: String?) {
        interactor?.updateUserInfo(
            email: email ?? "",
            name: name ?? "",
            lastname: lastname ?? "",
            age: Int(age ?? "Error")
        )
    }

    func updatePresentingViewController(_ vc: UIViewController?) {
        let nc = vc as? TabBarViewController
        let pvc = nc?.viewControllers?.compactMap {
            ($0 as? UINavigationController)?.viewControllers.first as? ProfileViewController
        }
        pvc?.first?.presenter?.viewDidLoad()
    }

    func exit() {
        Vibration.light.vibrate()
        router?.dismissEditProfile(view!)
    }
}

extension EditProfilePresenter: InteractorToPresenterEditProfileProtocol {
    func fetchUserInfo(_ user: UserEntity) {
        view?.updateUserInfo(user)
    }

    func fetchValidEmail(_ bool: Bool) {
        view?.updateEmailValidation(isEmailValid: bool)
    }

    func fetchValidName(_ bool: Bool) {
        view?.updateNameValidation(isNameValid: bool)
    }

    func fetchValidLastName(_ bool: Bool) {
        view?.updateLastNameValidation(isLastNameValid: bool)
    }

    func fetchValidAge(_ bool: Bool) {
        view?.updateAgeValidation(isAgeValid: bool)
    }

    func updateUserSuccess() {
        router?.saveEditProfile(view!)
        Vibration.success.vibrate()

    }

    func updateUserFailed(with error: Error) {
        router?.showErrorAlert(on: view!, title: "Ошибка", message: error.localizedDescription)
        Vibration.error.vibrate()
    }
}
