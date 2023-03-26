//
//  EventsInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//
//

import Firebase
import Foundation

class EventsInteractor: PresenterToInteractorEventsProtocol {
    // MARK: Properties

    weak var presenter: InteractorToPresenterEventsProtocol?
    var eventsClassification: EventsClassification

    var events: [EventEntity]?

    init(eventsClassification: EventsClassification) {
        self.eventsClassification = eventsClassification
    }

    func loadEventsFromNetwork(with info: String?) {
        FirebaseService.shared.loadEventsToCoreData { result in
            switch result {
            case .success:
                self.loadEventsFromCoreData(with: info)
                try? DataService.shared.saveContext()
                self.presenter?.reloadDataInTable()
            case let .failure(error):
                self.loadEventsFromCoreData(with: nil)
                self.presenter?.reloadDataInTable()
                self.presenter?.loadEventFromNetworkFailed(with: error)
            }
        }
    }

    func loadEventsFromCoreData(with predicate: String?) {
        switch eventsClassification {
        case .all:
            events = DataService.shared.getEvents(with: predicate)
        case .saved:
            guard let loggedId = Auth.auth().currentUser?.uid else {
                events = [EventEntity]()
                return
            }
            events = DataService.shared.getEvents(of: loggedId, with: predicate)
        }
    }

    func getEvent(at index: Int) -> EventEntity? {
        events?[index]
    }

    func getNavigationTitle() {
        switch eventsClassification {
        case .all:
            presenter?.fetchNavigationTitle(Constants.TabBarItemsNames.allEvents)
        case .saved:
            presenter?.fetchNavigationTitle(Constants.TabBarItemsNames.registeredTickets)
        }
    }

    func numberOfRowsInSection() -> Int {
        switch eventsClassification {
        case .all:
            return events?.count ?? 0
        case .saved:
            return events?.count ?? 0
        }
    }
}
