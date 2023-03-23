//
//  EventEntity+CoreDataProperties.swift
//  EventPasser
//
//  Created by Arseniy Matus on 08.12.2022.
//
//

import CoreData
import UIKit

public extension EventEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<EventEntity> {
        return NSFetchRequest<EventEntity>(entityName: "EventEntity")
    }

    @NSManaged var address: String?
    @NSManaged var id: String?
    @NSManaged var login: String?
    @NSManaged var max_guest_count: Int32
    @NSManaged var specification: String?
    @NSManaged var time_end: Date?
    @NSManaged var time_start: Date?
    @NSManaged var title: String?
    @NSManaged var tickets: NSSet?
    @NSManaged var image: Data?
    @NSManaged var imageURL: String?

    var wrappedId: String {
        id ?? ""
    }

    var wrappedLogin: String {
        login ?? ""
    }

    var wrappedTitle: String {
        title ?? ""
    }

    var wrappedAddress: String {
        address ?? ""
    }

    var wrappedMaxCount: Int {
        Int(max_guest_count)
    }

    var wrappedSpecification: String {
        specification ?? ""
    }

    var wrappedTimeEnd: Date {
        time_end ?? Date.distantFuture
    }

    var wrappedTimeStart: Date {
        time_start ?? Date.distantPast
    }

    var wrappedCurrentAmountOfTickets: Int {
        tickets?.count ?? 0
    }

    var isFull: Bool {
        wrappedCurrentAmountOfTickets >= wrappedMaxCount
    }

    var usersArray: [UserEntity] {
        let set = tickets as? Set<TicketEntity> ?? []
        return set.compactMap { $0.user }.sorted(by: { $0.wrappedFullName < $1.wrappedFullName })
    }

    var convertedImage: UIImage? {
        UIImage(data: image ?? Data())
    }
}

// MARK: Generated accessors for tickets

public extension EventEntity {
    @objc(addTicketsObject:)
    @NSManaged func addToTickets(_ value: TicketEntity)

    @objc(removeTicketsObject:)
    @NSManaged func removeFromTickets(_ value: TicketEntity)

    @objc(addTickets:)
    @NSManaged func addToTickets(_ values: NSSet)

    @objc(removeTickets:)
    @NSManaged func removeFromTickets(_ values: NSSet)
}
