//
//  UserEntity+CoreDataProperties.swift
//  EventPasser
//
//  Created by Arseniy Matus on 08.12.2022.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var age: Int16
    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var last_name: String?
    @NSManaged public var first_name: String?
    @NSManaged public var tickets: NSSet?
    @NSManaged public var is_staff: Bool
    @NSManaged public var is_teacher: Bool
    @NSManaged public var group: String?
    
    public var wrappedStringId: String {
        id?.uuidString ?? "wrong id"
    }
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedAge: Int {
        Int(age)
    }
    
    public var wrappedEmail: String {
        email ?? "Ошибка почты"
    }
    
    public var wrappedLastName: String {
        last_name ?? "Введите фамилию"
    }
    
    public var wrappedName: String {
        first_name ?? "Введите имя"
    }
    
    public var wrappedFullName: String {
        "\(wrappedName) \(wrappedLastName)"
    }
    
    public var eventsArray: [EventEntity] {
        let set = tickets as? Set<TicketEntity> ?? []
        return set.compactMap({ $0.event }).sorted(by: {
            $0.wrappedTimeStart < $1.wrappedTimeStart
        })
    }
}

// MARK: Generated accessors for tickets
extension UserEntity {

    @objc(addTicketsObject:)
    @NSManaged public func addToTickets(_ value: TicketEntity)

    @objc(removeTicketsObject:)
    @NSManaged public func removeFromTickets(_ value: TicketEntity)

    @objc(addTickets:)
    @NSManaged public func addToTickets(_ values: NSSet)

    @objc(removeTickets:)
    @NSManaged public func removeFromTickets(_ values: NSSet)
    
}
