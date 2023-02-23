//
//  EventSecurityContract.swift
//  EventPasser
//
//  Created by Arseniy Matus on 04.12.2022.
//  
//

import UIKit
import AVFoundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewEventSecurityProtocol: AnyObject {
    func updateTitle(with title: String)
    func reloadTableView()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterEventSecurityProtocol: NSObject, AnyObject, AVCaptureMetadataOutputObjectsDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var captureSession: AVCaptureSession! { get set }
    
    var view: PresenterToViewEventSecurityProtocol? { get set }
    var interactor: PresenterToInteractorEventSecurityProtocol? { get set }
    var router: PresenterToRouterEventSecurityProtocol? { get set }
    
    func refresh()
    func setEvent(_ event: EventEntity)
    func viewDidLoad()
    
    func startRunning()
    func stopRunning()
    
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorEventSecurityProtocol: AnyObject {
    
    var presenter: InteractorToPresenterEventSecurityProtocol? { get set }
    var event: EventEntity? { get set }
    var tickets: [UserEntity]? { get set }
    
    func updateEvent()
    func getTitle()
    func loadTickets()
    func getUser(at index: Int) -> UserEntity?
    func numberOfRowsInSection() -> Int
    
    func userPass(_ user: UserEntity, isInside: Bool, isOkay: Bool)
    
    func foundCode(code: String)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterEventSecurityProtocol: AnyObject {
    func fetchTitle(_ title: String)
    
    func validUserFound(user: UserEntity, isOkay: Bool)
    func userCodeError(message: String)
    
    func userToPass(_ user: UserEntity, isInside: Bool, isOkay: Bool)
    
    func reloadDataInTableView()
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterEventSecurityProtocol: AnyObject {
    func presentErrorAlert(on view: PresenterToViewEventSecurityProtocol, title: String, message: String, noPassHandler: ((UIAlertAction) -> ())?)
    func presentUserAlert(on view: PresenterToViewEventSecurityProtocol, user: UserEntity, isOkay: Bool, passHandler: ((UIAlertAction) -> Void)?, noPassHandler: ((UIAlertAction) -> ())?)
}
