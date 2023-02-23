//
//  Constants.swift
//  EventPasser
//
//  Created by Arseniy Matus on 06.11.2022.
//

import Foundation

struct Constants {
//    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    static let emailRegex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
        "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

    static let passRegex = "^[a-zA-Z0-9$@$!%*?&#^_., +'\"`{}()|\\[\\]\\\\/=<>;:\\-~]{8,64}$"

    static let service = "event-passer"
    static let loginService = "logged-user-email"
    static let eventService = "added-events-logins"

    static let eventCellIdentifier = "EventTableViewCell"
    static let userCellIdentifier = "UserTableViewCell"

    static let maxInfoLenght = 150
    static let maxGuestsCount = 10000
    static let minGuestsCount = 1

    static let dateFormatter = "yyyy-MM-dd'T'HH:mm:ssZ"

    enum TabBarItemsNames {
        static let allEvents = "Мероприятия"
        static let registeredTickets = "Мои билеты"
        static let profile = "Профиль"
    }

    enum CoreDataEntities {
        static let userEntityName = "UserEntity"
        static let eventEntityName = "EventEntity"
        static let ticketEntityName = "TicketEntity"
    }

    enum NetworkURL {
        static let baseURL = "http://178.128.137.157/api/v1"
    }
}
