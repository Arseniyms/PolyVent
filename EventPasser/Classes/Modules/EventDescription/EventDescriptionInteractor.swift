//
//  EventDescriptionInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 19.11.2022.
//
//

import Foundation
import Firebase

class EventDescriptionInteractor: PresenterToInteractorEventDescriptionProtocol {
    // MARK: Properties

    weak var presenter: InteractorToPresenterEventDescriptionProtocol?
    var event: EventEntity?
    var isUserAlreadySet: Bool?

    var workWithTicketClosure: (() -> Void)?

    func loadEvent() {
        guard let event else { return }
        presenter?.fetchEventInfo(event)
    }

    func loadIsUserAlreadySet() {
        guard let loggedId = Auth.auth().currentUser?.uid, let eventId = event?.id else {
            return
        }
        isUserAlreadySet = DataService.shared.isUserAlreadySetToEvent(userId: loggedId, eventId: eventId)

        if isUserAlreadySet ?? false {
            workWithTicketClosure = { [weak self] in
                FirebaseService.shared.deleteTicket(of: loggedId, to: eventId) { error in
                    guard let error else {
                        self?.completion(ticketId: "", loggedId: loggedId, eventId: eventId, ticketFunc: DataService.shared.unsetTicket)
                        return
                    }
                    self?.presenter?.setTicketWentWrong(with: error)
                }
            }
        } else {
            workWithTicketClosure = { [weak self] in
                FirebaseService.shared.createTicket(of: loggedId, to: eventId) { result in
                    switch result {
                    case .success(let success):
                        self?.completion(ticketId: success, loggedId: loggedId, eventId: eventId, ticketFunc: DataService.shared.setTicket)
                        return
                    case .failure(let error):
                        self?.presenter?.setTicketWentWrong(with: error)
                    }
                }
            }
        }
    }

    func isEventAvailable() -> Bool {
        guard let event else { return false }
        return event.wrappedCurrentAmountOfTickets < event.wrappedMaxCount
    }

    func workWithTicket() {
        do {
            workWithTicketClosure?()
            try DataService.shared.saveContext()
        } catch {
            presenter?.setTicketWentWrong(with: error)
        }
    }

    private func completion(ticketId: String, loggedId: String, eventId: String, ticketFunc: (String, String, String) throws -> Void) {
        do {
            try ticketFunc(ticketId, loggedId, eventId)
            self.presenter?.setTicketDone()
        } catch {
            self.presenter?.setTicketWentWrong(with: error)
        }
    }
}
