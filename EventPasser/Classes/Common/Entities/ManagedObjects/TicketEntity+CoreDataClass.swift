//
//  TicketEntity+CoreDataClass.swift
//  EventPasser
//
//  Created by Arseniy Matus on 08.12.2022.
//
//

import Foundation
import CoreData

@objc(TicketEntity)
public class TicketEntity: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id, event_id, user_id, is_inside
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {
            fatalError("Missing ManagedObjectContext")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let eventId = try container.decode(String.self, forKey: .event_id)
        let userId =  try container.decode(String.self, forKey: .user_id)
        self.is_inside = try container.decode(Bool.self, forKey: .is_inside)
        
        let event = DataService.shared.getEvent(predicate: NSPredicate(format: "id == %@", eventId))
        let user = DataService.shared.getUser(predicate: NSPredicate(format: "id == %@", userId))
        
        self.event = event
        self.user = user
        self.id = try container.decode(String.self, forKey: .id)
    }
}
