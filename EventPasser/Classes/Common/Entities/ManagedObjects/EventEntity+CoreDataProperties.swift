//
//  EventEntity+CoreDataProperties.swift
//  EventPasser
//
//  Created by Arseniy Matus on 08.12.2022.
//
//

import Foundation
import CoreData


extension EventEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventEntity> {
        return NSFetchRequest<EventEntity>(entityName: "EventEntity")
    }

    @NSManaged public var address: String?
    @NSManaged public var id: String?
    @NSManaged public var login: String?
    @NSManaged public var max_guest_count: Int32
    @NSManaged public var specification: String?
    @NSManaged public var time_end: Date?
    @NSManaged public var time_start: Date?
    @NSManaged public var title: String?
    @NSManaged public var tickets: NSSet?

    public var wrappedId: String {
        id ?? ""
    }
    
    public var wrappedLogin: String {
        login ?? ""
    }
    
    public var wrappedTitle: String {
        title ?? ""
    }
    
    public var wrappedAddress: String {
        address ?? ""
    }
    
    public var wrappedMaxCount: Int {
        Int(max_guest_count)
    }
    
    public var wrappedSpecification: String {
        specification ?? ""
    }
    
    public var wrappedTimeEnd: Date {
        time_end ?? Date.distantFuture
    }
    
    public var wrappedTimeStart: Date {
        time_start ?? Date.distantPast
    }
    
    public var wrappedCurrentAmountOfTickets: Int {
        tickets?.count ?? 0
    }
    
    public var usersArray: [UserEntity] {
        let set = tickets as? Set<TicketEntity> ?? []
        return set.compactMap({ $0.user }).sorted(by: { $0.wrappedFullName < $1.wrappedFullName })
    }
    
}

// MARK: Generated accessors for tickets
extension EventEntity {

    @objc(addTicketsObject:)
    @NSManaged public func addToTickets(_ value: TicketEntity)

    @objc(removeTicketsObject:)
    @NSManaged public func removeFromTickets(_ value: TicketEntity)

    @objc(addTickets:)
    @NSManaged public func addToTickets(_ values: NSSet)

    @objc(removeTickets:)
    @NSManaged public func removeFromTickets(_ values: NSSet)

}
