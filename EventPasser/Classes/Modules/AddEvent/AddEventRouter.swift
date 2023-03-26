//
//  AddEventRouter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.11.2022.
//  
//

import Foundation
import UIKit

class AddEventRouter: PresenterToRouterAddEventProtocol {
    
    // MARK: Static methods
    static func createModule() -> UIViewController {
        
        let viewController = AddEventViewController()
        
        let presenter: ViewToPresenterAddEventProtocol & InteractorToPresenterAddEventProtocol = AddEventPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = AddEventRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = AddEventInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func popViewController(_ view: PresenterToViewAddEventProtocol) {
        let vc = view as! AddEventViewController
        
        vc.navigationController?.popViewController(animated: true)
    }
    
    
    func presentErrorAlert(on view: PresenterToViewAddEventProtocol, title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let vc = view as? AddEventViewController
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: handler))
        
        vc?.present(alert, animated: true)
    }
    
    func openImagePicker(on view: PresenterToViewAddEventProtocol, delegate: ViewToPresenterAddEventProtocol) {
        let vc = view as? AddEventViewController
        
        let picker = UIImagePickerController()
        picker.delegate = delegate
        picker.allowsEditing = true
        vc?.present(picker, animated: true)
    }
    
}
