//
//  EventsRouter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//  
//

import Foundation
import UIKit

class EventsRouter: PresenterToRouterEventsProtocol {
    
    // MARK: Static methods
    static func createModule(eventsClassification: EventsClassification) -> UINavigationController {
        
        let viewController = EventsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        let presenter: ViewToPresenterEventsProtocol & InteractorToPresenterEventsProtocol = EventsPresenter()

        viewController.presenter = presenter
        viewController.presenter?.router = EventsRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = EventsInteractor(eventsClassification: eventsClassification)
        viewController.presenter?.interactor?.presenter = presenter
        
        return navigationController
    }
    
    func presentEventDescription(on view: PresenterToViewEventsProtocol, with event: EventEntity) {
        let eventDescriptionViewController = EventDescriptionRouter.createModule(with: event)
        
        let vc = view as! EventsViewController
        
        vc.present(eventDescriptionViewController, animated: true)
    }
    
    func presentAddEvent(on view: PresenterToViewEventsProtocol) {
        let addEventVC = AddEventRouter.createModule()
        
        let vc = view as! EventsViewController
        
        vc.navigationController?.pushViewController(addEventVC, animated: true)
    }
    
    func pushLoginEvent(on view: PresenterToViewEventsProtocol) {
        let loginEventVC = EventLoginRouter.createModule()
        
        let vc = view as! EventsViewController
        vc.navigationController?.pushViewController(loginEventVC, animated: true)
    }
    
    func getEventPreview(of event: EventEntity) -> UIViewController? {
        let eventModule = EventDescriptionRouter.createModule(with: event)
        
        return eventModule
    }
    
    func presentErrorAlert(on view: PresenterToViewEventsProtocol, title: String, message: String) {
        let vc = view as! EventsViewController
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true)
    }
}
