//
//  AddEventContract.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.11.2022.
//  
//

import UIKit


// MARK: View Output (Presenter -> View)
protocol PresenterToViewAddEventProtocol: AnyObject {
    func updateChosenImage(with image: UIImage)
    func removeChosenImage()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterAddEventProtocol: NSObject, AnyObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var view: PresenterToViewAddEventProtocol? { get set }
    var interactor: PresenterToInteractorAddEventProtocol? { get set }
    var router: PresenterToRouterAddEventProtocol? { get set }
    
    func viewDidLoad()
    func saveEventInfo(name: String, address: String, maxGuestsCount: Int, specification: String, timeEnd: Date, timeStart: Date, login: String?, password: String?, confirmPassword: String?, image: UIImage?)
    
    func startImagePicker()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorAddEventProtocol: AnyObject {
    
    var presenter: InteractorToPresenterAddEventProtocol? { get set }
    
    func isUserStaff()
    func saveEvent(name: String, address: String, maxGuestsCount: Int, specification: String, timeEnd: Date, timeStart: Date, login: String?, password: String?, confirmPassword: String?, image: UIImage?)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterAddEventProtocol: AnyObject {
    func saveEventSuccess()
    func saveEventFailure(with error: Error, handler: ((UIAlertAction) -> Void)?)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterAddEventProtocol: AnyObject {
    func popViewController(_ view: PresenterToViewAddEventProtocol)
    func presentErrorAlert(on view: PresenterToViewAddEventProtocol, title: String, message: String, handler: ((UIAlertAction) -> Void)?)
    func openImagePicker(on view: PresenterToViewAddEventProtocol, delegate: ViewToPresenterAddEventProtocol)
}
