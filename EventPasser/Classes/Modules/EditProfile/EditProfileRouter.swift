//
//  EditProfileRouter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 05.11.2022.
//  
//

import UIKit

class EditProfileRouter: PresenterToRouterEditProfileProtocol {
    
    // MARK: Static methods
    static func createModule() -> UINavigationController {
        
        let viewController = EditProfileViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let presenter: ViewToPresenterEditProfileProtocol & InteractorToPresenterEditProfileProtocol = EditProfilePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = EditProfileRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = EditProfileInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return navigationController
    }
    
    
    func dismissEditProfile(_ view: PresenterToViewEditProfileProtocol) {
        let vc = view as! EditProfileViewController
        
        vc.dismiss(animated: true)
    }
    
    func saveEditProfile(_ view: PresenterToViewEditProfileProtocol) {
        let vc = view as! EditProfileViewController
        vc.presenter?.updatePresentingViewController(vc.presentingViewController)
        
        vc.dismiss(animated: true)
    }
    
    func exitApp(on view: PresenterToViewEditProfileProtocol) {
        let signInViewController = SignInRouter.createModule()
        
        let vc = view as! EditProfileViewController
        guard let window = vc.view.window else {
            return
        }
        window.switchRootViewController(signInViewController)
    }
    
    func showErrorAlert(on view: PresenterToViewEditProfileProtocol, title: String, message: String) {
        let vc = view as! EditProfileViewController

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true)
    }
    
    func showDeleteAlert(on view: PresenterToViewEditProfileProtocol, handler: ((UIAlertAction) -> Void)?) {
        let vc = view as! EditProfileViewController
        
        let alert = UIAlertController(title: "Удаление акканута", message: "Вы уверены, что хотите удалить аккаунт? Все данные будут утеряны.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: handler))
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        vc.present(alert, animated: true)
    }
    
}
