//
//  SignUpRouter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//  
//

import Foundation
import UIKit

class SignUpRouter: PresenterToRouterSignUpProtocol {
    
    // MARK: Static methods
    static func createModule() -> UIViewController {
        
        let viewController = SignUpViewController()
        
        let presenter: ViewToPresenterSignUpProtocol & InteractorToPresenterSignUpProtocol = SignUpPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = SignUpRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = SignUpInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func goBackToSignIn(_ view: PresenterToViewSignUpProtocol) {
        let vc = view as! SignUpViewController
        vc.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(on view: PresenterToViewSignUpProtocol, title: String, message: String, handler: ((UIAlertAction) -> ())?) {
        let vc = view as! SignUpViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))

        vc.present(alert, animated: true)
    }
    
}
