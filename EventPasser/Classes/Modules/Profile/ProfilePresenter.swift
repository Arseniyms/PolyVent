//
//  ProfilePresenter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//  
//

import UIKit

class ProfilePresenter: ViewToPresenterProfileProtocol {
    // MARK: Properties
    weak var view: PresenterToViewProfileProtocol?
    var interactor: PresenterToInteractorProfileProtocol?
    var router: PresenterToRouterProfileProtocol?
    
    func goToSignIn() {
        interactor?.deleteLoggedUser()
        router?.switchToSignIn(on: view!)
    }
    
    func goToEditProfile() {
        router?.presentEditProfile(on: view!)
    }
    
    func viewDidLoad() {
        interactor?.getUser()
    }
    
}

extension ProfilePresenter: InteractorToPresenterProfileProtocol {
    
    func loadNetworkError() {
        router?.presentNetworkError(on: view!, title: "Ошибка сети", message: "Ошибка подключения к серверу")
        fetchQrImageFailure()
    }
    
    func loggedUserError() {
        self.goToSignIn()
    }
    
    func fetchUserInfo(_ user: UserEntity) {
        view?.updateUserInfo(user)
    }
    
    func fetchQrImageSuccess(with image: UIImage) {
        view?.updateQrImage(with: image)
    }
    
    func fetchQrImageFailure() {
        view?.updateQrImage(with: UIImage(systemName: "xmark.circle")!.withTintColor(.red))
    }
    
}
