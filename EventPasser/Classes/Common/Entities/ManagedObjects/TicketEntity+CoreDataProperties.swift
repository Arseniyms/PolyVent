//
//  TicketEntity+CoreDataProperties.swift
//  EventPasser
//
//  Created by Arseniy Matus on 08.12.2022.
//
//

import Foundation
import CoreData


extension TicketEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TicketEntity> {
        return NSFetchRequest<TicketEntity>(entityName: "TicketEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var is_inside: Bool
    @NSManaged public var event: EventEntity?
    @NSManaged public var user: UserEntity?

}
