//
//  EventLoginRouter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 04.12.2022.
//  
//

import Foundation
import UIKit

class EventLoginRouter: PresenterToRouterEventLoginProtocol {
    // MARK: Static methods
    static func createModule() -> UIViewController {
        
        let viewController = EventLoginViewController()
        
        let presenter: ViewToPresenterEventLoginProtocol & InteractorToPresenterEventLoginProtocol = EventLoginPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = EventLoginRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = EventLoginInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func pushEventDescription(on view: PresenterToViewEventLoginProtocol, with event: EventEntity) {
        
        let eventSecurityVC = EventSecurityRouter.createModule(event: event)
        let vc = view as! EventLoginViewController
        vc.navigationController?.pushViewController(eventSecurityVC, animated: true)
    }
    
    func presentErrorAlert(on view: PresenterToViewEventLoginProtocol, title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let vc = view as? EventLoginViewController
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: handler))
        
        vc?.present(alert, animated: true)
    }
}
