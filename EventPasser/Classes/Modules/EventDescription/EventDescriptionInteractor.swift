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
//            workWithTicketClosure = { [weak self] in
//                NetworkService.shared.deleteTicket(of: loggedId, to: eventId) { result in
//                    self?.completion(loggedId: loggedId, eventId: eventId, result: result, ticketFunc: DataService.shared.unsetTicket)
//                }
//            }
        } else {
            workWithTicketClosure = { [weak self] in
                FirebaseService.shared.createTicket(of: loggedId, to: eventId) { error in
                    guard let error else {
                        self?.completion(loggedId: loggedId, eventId: eventId, ticketFunc: DataService.shared.setTicket)
                        return
                    }
                    self?.presenter?.setTicketWentWrong(with: error)
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

    private func completion(loggedId: String, eventId: String, ticketFunc: (String, String) throws -> Void) {
        do {
            try ticketFunc(loggedId, eventId)
            self.presenter?.setTicketDone()
        } catch {
            self.presenter?.setTicketWentWrong(with: error)
        }
    }
}
