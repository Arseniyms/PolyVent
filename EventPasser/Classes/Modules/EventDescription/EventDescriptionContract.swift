//
//  EventDescriptionContract.swift
//  EventPasser
//
//  Created by Arseniy Matus on 19.11.2022.
//  
//

import UIKit


// MARK: View Output (Presenter -> View)
protocol PresenterToViewEventDescriptionProtocol: AnyObject {
    func updateSetButton(with string: String, isEnabled: Bool, with color: UIColor)
    func updateEventInfo(_ event: EventEntity)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterEventDescriptionProtocol: AnyObject {
    
    var view: PresenterToViewEventDescriptionProtocol? { get set }
    var interactor: PresenterToInteractorEventDescriptionProtocol? { get set }
    var router: PresenterToRouterEventDescriptionProtocol? { get set }
    
    func viewDidLoad()
    func signToEvent()
    func updatePresentingViewController(_ vc: UIViewController?)
    func exit()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorEventDescriptionProtocol: AnyObject {
    var presenter: InteractorToPresenterEventDescriptionProtocol? { get set }
    var event: EventEntity? { get set }
    var isUserAlreadySet: Bool? { get set }
    
    func loadIsUserAlreadySet()
    func loadEvent()
    func workWithTicket()
    func isEventAvailable() -> Bool
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterEventDescriptionProtocol: AnyObject {
    func fetchEventInfo(_ event: EventEntity)
    
    func setTicketDone()
    func setTicketWentWrong(with error: Error)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterEventDescriptionProtocol: AnyObject {
    func goBack(_ view: PresenterToViewEventDescriptionProtocol)
    func presentErrorAlert(on view: PresenterToViewEventDescriptionProtocol, title: String, message: String)
}
