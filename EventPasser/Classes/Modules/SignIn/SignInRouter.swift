//
//  SignInRouter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//  
//

import Foundation
import UIKit

// Start view
class SignInRouter: PresenterToRouterSignInProtocol {
    // MARK: Static methods
    static func createModule() -> UINavigationController {
        let viewController = SignInViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let presenter: ViewToPresenterSignInProtocol & InteractorToPresenterSignInProtocol = SignInPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = SignInRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = SignInInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return navigationController
    }
    
    func pushToSignUpController(on view: PresenterToViewSignInProtocol) {
        let signUpViewController = SignUpRouter.createModule()
        
        let vc = view as! SignInViewController
        vc.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    func pushToMainController(on view: PresenterToViewSignInProtocol) {
        let mainViewController = TabBarRouter.createModule()
                
        let vc = view as! SignInViewController
        guard let window = vc.view.window else {
            return
        }
        window.switchRootViewController(mainViewController)
    }
    
    func showErrorAlert(on view: PresenterToViewSignInProtocol, title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let vc = view as! SignInViewController
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        vc.present(alert, animated: true)
    }
    
}
