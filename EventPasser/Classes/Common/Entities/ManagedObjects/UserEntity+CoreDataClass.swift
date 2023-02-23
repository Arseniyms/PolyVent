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
    enum CodingKeys: String, CodingKey {
        case id, name = "first_name", last_name, age, is_superuser, is_staff, email = "username"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {
            fatalError("Missing ManagedObjectContext")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stringId = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: stringId)
        self.email = try container.decode(String?.self, forKey: .email)
        self.name = try container.decode(String?.self, forKey: .name)
        self.last_name = try container.decode(String?.self, forKey: .last_name)
        self.age = try container.decode(Int16?.self, forKey: .age) ?? 0
        self.is_superuser = try container.decode(Bool.self, forKey: .is_superuser)
        self.is_staff = try container.decode(Bool.self, forKey: .is_staff)
        
    }
}
