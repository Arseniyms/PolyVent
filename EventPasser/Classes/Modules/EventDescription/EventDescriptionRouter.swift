//
//  EventDescriptionRouter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 19.11.2022.
//  
//

import Foundation
import UIKit

class EventDescriptionRouter: PresenterToRouterEventDescriptionProtocol {
    
    // MARK: Static methods
    static func createModule(with event: EventEntity) -> UINavigationController {
        let viewController = EventDescriptionViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let presenter: ViewToPresenterEventDescriptionProtocol & InteractorToPresenterEventDescriptionProtocol = EventDescriptionPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = EventDescriptionRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = EventDescriptionInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.event = event
        
        return navigationController
    }
    
    
    func goBack(_ view: PresenterToViewEventDescriptionProtocol) {
        let vc = view as! EventDescriptionViewController
        
        vc.presenter?.updatePresentingViewController(vc.presentingViewController)
        vc.dismiss(animated: true)
    }
    
    func presentErrorAlert(on view: PresenterToViewEventDescriptionProtocol, title: String, message: String) {
        let vc = view as! EventDescriptionViewController
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true)
    }
    
}
