//
//  EventsContract.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//  
//

import UIKit


// MARK: View Output (Presenter -> View)
protocol PresenterToViewEventsProtocol: AnyObject {
    func setNavigationTitle(_ title: String)
    func reloadData()
    func stopRefreshing()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterEventsProtocol: NSObject, AnyObject, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    var view: PresenterToViewEventsProtocol? { get set }
    var interactor: PresenterToInteractorEventsProtocol? { get set }
    var router: PresenterToRouterEventsProtocol? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    
    func refresh(with searchInfo: String?)
    func goToEventDescription(with event: EventEntity)
    func goToAddEvent()
    func goToLoginEvent()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorEventsProtocol: AnyObject {
    var eventsClassification: EventsClassification { get }
    var presenter: InteractorToPresenterEventsProtocol? { get set }
    
    var events: [EventEntity]? { get set }
    
    func loadEventsFromCoreData(with predicate: String?)
    func loadEventsFromNetwork(with info: String?)
    func getEvent(at index: Int) -> EventEntity?
    func getNavigationTitle()
    func numberOfRowsInSection() -> Int
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterEventsProtocol: AnyObject {
    func fetchNavigationTitle(_ title: String)
    
    func reloadDataInTable()
    func loadEventFromNetworkFailed(with error: Error)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterEventsProtocol: AnyObject {
    func presentEventDescription(on view: PresenterToViewEventsProtocol, with event: EventEntity)
    func presentAddEvent(on view: PresenterToViewEventsProtocol)
    func pushLoginEvent(on view: PresenterToViewEventsProtocol)
    func getEventPreview(of: EventEntity) -> UIViewController?
    
    func presentErrorAlert(on view: PresenterToViewEventsProtocol, title: String, message: String)
}
