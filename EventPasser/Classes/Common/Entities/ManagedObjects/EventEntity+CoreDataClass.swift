//
//  EventEntity+CoreDataClass.swift
//  EventPasser
//
//  Created by Arseniy Matus on 08.12.2022.
//
//

import Foundation
import CoreData

@objc(EventEntity)
public class EventEntity: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, login, address, time_start, time_end, max_guest_count
        case specification = "description"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {
            fatalError("Missing ManagedObjectContext")
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stringId = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: stringId)
        self.title = try container.decode(String?.self, forKey: .title)
        self.login = try container.decode(String?.self, forKey: .login)
        self.address = try container.decode(String?.self, forKey: .address)
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormatter
        var dateString = try container.decode(String?.self, forKey: .time_start) ?? Date().description
        self.time_start = formatter.date(from: dateString)
        dateString = try container.decode(String?.self, forKey: .time_end) ?? Date().description
        self.time_end = formatter.date(from: dateString)
        self.max_guest_count = try container.decode(Int32?.self, forKey: .max_guest_count) ?? 0
        self.specification = try container.decode(String?.self, forKey: .specification)

    }
}
