//
//  EventSecurityInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 04.12.2022.
//
//

import Foundation

class EventSecurityInteractor: PresenterToInteractorEventSecurityProtocol {
    // MARK: Properties

    weak var presenter: InteractorToPresenterEventSecurityProtocol?

    var event: EventEntity?
    var tickets: [UserEntity]?

    func getTitle() {
        guard let event else { return }
        presenter?.fetchTitle(event.wrappedTitle)
    }

    func updateEvent() {
        guard let event else { return }
        FirebaseService.shared.loadUsersToCoreData { result in
            switch result {
            case .success:
                FirebaseService.shared.loadTicketsToCoreData { result in
                    switch result {
                    case .success:
                        self.event = DataService.shared.getEvent(predicate: NSPredicate(format: "id == %@", event.wrappedId))
                        self.loadTickets()
                        self.presenter?.reloadDataInTableView()
                    case let .failure(error):
                        self.presenter?.userCodeError(message: error.localizedDescription)
                    }
                }
            case let .failure(error):
                self.presenter?.userCodeError(message: error.localizedDescription)
            }
        }
    }

    func loadTickets() {
        tickets = event?.usersArray
    }

    func getUser(at index: Int) -> UserEntity? {
        if index < tickets?.count ?? 0 {
            return tickets?[index]
        }
        return nil
    }

    func numberOfRowsInSection() -> Int {
        event?.wrappedMaxCount ?? 0
    }

    func foundCode(code: String) {
        guard let event else {
            fatalError("Ошибка мероприятия. Повторите попытку входа")
        }

        let user = DataService.shared.getUser(predicate: NSPredicate(format: "id == %@", code))
        guard let user else {
            presenter?.userCodeError(message: "Некорректный код")
            return
        }
        if DataService.shared.isUserInside(user, in: event) {
            presenter?.userCodeError(message: "Пользователь уже внутри")
            return
        }

        let isOkay = DataService.shared.isUserAlreadySetToEvent(userId: user.wrappedStringId, eventId: event.wrappedId)
        presenter?.validUserFound(user: user, isOkay: isOkay)
    }

    func userPass(_ user: UserEntity, isInside: Bool, isOkay: Bool) {
        if !isOkay { return }
        do {
            guard let event else { throw TicketErrors.invalidEventId }
            FirebaseService.shared.userGoInside(user.wrappedStringId, to: event.wrappedId, isInside: isInside) { result in
                switch result {
                case let .success(success):
                    do {
                        switch success {
                        case .OK:
                            try DataService.shared.userGotToEvent(user, to: event, isInside: isInside)
                            try DataService.shared.saveContext()
                            self.presenter?.reloadDataInTableView()
                        default:
                            throw NetworkErrors.serverError
                        }
                    } catch {
                        self.presenter?.userCodeError(message: error.localizedDescription)
                    }

                case let .failure(error):
                    self.presenter?.userCodeError(message: error.localizedDescription)
                }
            }
        } catch {
            presenter?.userCodeError(message: error.localizedDescription)
        }
    }
}
