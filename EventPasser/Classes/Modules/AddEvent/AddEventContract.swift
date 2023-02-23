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
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterAddEventProtocol: AnyObject {
    
    var view: PresenterToViewAddEventProtocol? { get set }
    var interactor: PresenterToInteractorAddEventProtocol? { get set }
    var router: PresenterToRouterAddEventProtocol? { get set }
    
    func viewDidLoad()
    func saveEventInfo(id: UUID, name: String, address: String, maxGuestsCount: Int, specification: String, timeEnd: Date, timeStart: Date, login: String?, password: String?, confirmPassword: String?)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorAddEventProtocol: AnyObject {
    
    var presenter: InteractorToPresenterAddEventProtocol? { get set }
    
    func isUserStaff()
    func saveEvent(id: UUID, name: String, address: String, maxGuestsCount: Int, specification: String, timeEnd: Date, timeStart: Date, login: String?, password: String?, confirmPassword: String?)
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
}
