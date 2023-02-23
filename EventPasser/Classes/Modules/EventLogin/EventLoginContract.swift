//
//  EventLoginContract.swift
//  EventPasser
//
//  Created by Arseniy Matus on 04.12.2022.
//  
//

import UIKit


// MARK: View Output (Presenter -> View)
protocol PresenterToViewEventLoginProtocol: AnyObject {
   func loginFailed()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterEventLoginProtocol: AnyObject {
    
    var view: PresenterToViewEventLoginProtocol? { get set }
    var interactor: PresenterToInteractorEventLoginProtocol? { get set }
    var router: PresenterToRouterEventLoginProtocol? { get set }
        
    func signInTapped(login: String, password: String)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorEventLoginProtocol: AnyObject {
    
    var presenter: InteractorToPresenterEventLoginProtocol? { get set }
    
    func signIn(login: String, password: String)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterEventLoginProtocol: AnyObject {
    func signInSuccess(with event: EventEntity)
    func signInFailure(with error: Error)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterEventLoginProtocol: AnyObject {
    func pushEventDescription(on view: PresenterToViewEventLoginProtocol, with event: EventEntity)
    func presentErrorAlert(on view: PresenterToViewEventLoginProtocol, title: String, message: String, handler: ((UIAlertAction) -> Void)?)
}
