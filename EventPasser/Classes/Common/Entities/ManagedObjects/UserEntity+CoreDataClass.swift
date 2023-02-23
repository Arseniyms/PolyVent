//
//  UserEntity+CoreDataClass.swift
//  EventPasser
//
//  Created by Arseniy Matus on 08.12.2022.
//
//

import Foundation
import CoreData

@objc(UserEntity)
public class UserEntity: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, first_name, last_name, age, is_staff, group, is_teacher
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {
            fatalError("Missing ManagedObjectContext")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stringId = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: stringId)
//        self.email = try container.decode(String?.self, forKey: .email)
        self.first_name = try container.decode(String?.self, forKey: .first_name)
        self.last_name = try container.decode(String?.self, forKey: .last_name)
        self.age = try container.decode(Int16?.self, forKey: .age) ?? 0
        self.is_staff = try container.decode(Bool.self, forKey: .is_staff)
        self.is_teacher = try container.decode(Bool.self, forKey: .is_teacher)
        self.group = try container.decode(String?.self, forKey: .group)

    }
}
