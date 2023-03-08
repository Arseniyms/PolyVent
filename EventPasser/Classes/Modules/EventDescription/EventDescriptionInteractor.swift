//
//  EventDescriptionInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 19.11.2022.
//
//

import Foundation

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
        guard let loggedId = LoginService.shared.getLoggedUser(), let eventId = event?.id else {
            return
        }
//        isUserAlreadySet = DataService.shared.isUserAlreadySetToEvent(userId: loggedId, eventId: eventId)

//        if isUserAlreadySet ?? false {
//            workWithTicketClosure = { [weak self] in
//                NetworkService.shared.deleteTicket(of: loggedId, to: eventId) { result in
//                    self?.completion(loggedId: loggedId, eventId: eventId, result: result, ticketFunc: DataService.shared.unsetTicket)
//                }
//            }
//        } else {
//            workWithTicketClosure = { [weak self] in
//                NetworkService.shared.setTicket(user: loggedId, event: eventId) { result in
//                    self?.completion(loggedId: loggedId, eventId: eventId, result: result, ticketFunc: DataService.shared.setTicket)
//                }
//            }
//        }
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

    private func completion(loggedId: UUID, eventId: UUID, result: Result<ResponseStatus, Error>, ticketFunc: (UUID, UUID) throws -> Void) {
        do {
            switch result {
            case let .success(response):
                switch response {
                case .deleted, .created:
                    try ticketFunc(loggedId, eventId)
                    self.presenter?.setTicketDone()
                default:
                    throw NetworkErrors.serverError
                }
            case let .failure(error):
                throw error
            }
        } catch {
            self.presenter?.setTicketWentWrong(with: error)
        }
    }
}
