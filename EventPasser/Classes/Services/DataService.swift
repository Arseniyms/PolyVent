//
//  DataService.swift
//  EventPasser
//
//  Created by Arseniy Matus on 15.11.2022.
//

import CoreData
import UIKit

class DataService {
    private init() {
    }

    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    
    private static let userEnt = NSEntityDescription.entity(forEntityName: Constants.CoreDataEntities.userEntityName, in: context)
    private static let eventEnt = NSEntityDescription.entity(forEntityName: Constants.CoreDataEntities.eventEntityName, in: context)
    private static let ticketEnt = NSEntityDescription.entity(forEntityName: Constants.CoreDataEntities.ticketEntityName, in: context)

    static var shared: DataService { DataService() }

    func saveContext() throws {
        try DataService.context.save()
    }
    
    // MARK: Users

    func getUser(predicate: NSPredicate) -> UserEntity? {
        let request = NSFetchRequest<UserEntity>(entityName: Constants.CoreDataEntities.userEntityName)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        return try? DataService.context.fetch(request).first
    }

    func updateUser(id: String, email: String, name: String, lastname: String, age: Int?) throws {
        let request = NSFetchRequest<UserEntity>(entityName: Constants.CoreDataEntities.userEntityName)
        request.predicate = NSPredicate(format: "id = %@", id)
        request.returnsObjectsAsFaults = false

        let result = try DataService.context.fetch(request)
        let updateUser = result.first
        updateUser?.first_name = name
        updateUser?.email = email
        updateUser?.last_name = lastname
        if let age {
            updateUser?.age = Int16(age)
        }

//        try DataService.context.save()
    }

    @available(*, deprecated)
    func saveNewUser(email: String) throws {
        if !isEmailAlreadyExist(email) {
            let newUser = NSManagedObject(entity: DataService.userEnt!, insertInto: DataService.context)

            newUser.setValue(email, forKey: "email")
            newUser.setValue(UUID(), forKey: "id")

//            try DataService.context.save()
        } else {
            throw AuthorizationError.emailAlreadyExist
        }
    }

    private func isEmailAlreadyExist(_ email: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreDataEntities.userEntityName)
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        return ((try? DataService.context.count(for: fetchRequest)) ?? 0) > 0
    }



    // MARK: Events
    
    func getEvent(predicate: NSPredicate) -> EventEntity? {
        let request = NSFetchRequest<EventEntity>(entityName: Constants.CoreDataEntities.eventEntityName)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        return try? DataService.context.fetch(request).first
    }

    func getEvents(with info: String?) -> [EventEntity] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreDataEntities.eventEntityName)
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "time_start", ascending: true)]
        if let info, !info.isEmpty {
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR address CONTAINS[cd] %@ OR specification CONTAINS[cd] %@", info, info, info)
        }
        let result = try? DataService.context.fetch(request) as? [EventEntity]
        return result ?? [EventEntity]()
    }

    func saveEvent(id: String, login: String?, name: String, address: String, maxGuestsCount: Int, specification: String, timeEnd: Date, timeStart: Date) throws -> EventEntity {
        guard let login else { throw EventAuthorizationError.saveError }
        if !isEventAlreadyExist(login: login) {
            let newEvent = EventEntity(context: DataService.context)

            newEvent.id = id
            newEvent.login = login
            newEvent.title = name
            newEvent.address = address
            newEvent.max_guest_count = Int32(maxGuestsCount)
            newEvent.specification = specification
            newEvent.time_end = timeEnd
            newEvent.time_start = timeStart

            return newEvent
        } else {
            throw EventAuthorizationError.eventAlreadyExist
        }
        
    }

    private func isEventAlreadyExist(login: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreDataEntities.eventEntityName)
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)

        return ((try? DataService.context.count(for: fetchRequest)) ?? 0) > 0
    }
    
    func deleteFromCoreData(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let arrUsrObj = try DataService.context.fetch(fetchRequest)
            for usrObj in arrUsrObj as! [NSManagedObject] {
                DataService.context.delete(usrObj)
            }
            try DataService.context.save()
        } catch let error as NSError {
            print("delete fail--",error)
        }
    }
    
    // MARK: Tickets
    
    func getEvents(of userId: UUID, with info: String?) -> [EventEntity] {
        guard let user = try? getUserEntityById(userId) else { return [EventEntity]() }
        if let info, !info.isEmpty {
            return user.eventsArray.filter {
                $0.wrappedTitle.lowercased().contains(info.lowercased()) ||
                $0.wrappedAddress.lowercased().contains(info.lowercased()) ||
                $0.wrappedSpecification.lowercased().contains(info.lowercased())
            }
        }
        
        return user.eventsArray
    }
    
    func setTicket(userId: UUID, eventId: UUID) throws {
        let updateUser = try getUserEntityById(userId)
        let updateEvent = try getEventEntityById(eventId)
        
        if updateUser.eventsArray.contains(updateEvent) {
            throw TicketErrors.ticketAlreadySet
        }
        if updateEvent.wrappedCurrentAmountOfTickets >= updateEvent.wrappedMaxCount {
            throw TicketErrors.notEnoughSpace
        }
        
        let newTicket = NSManagedObject(entity: DataService.ticketEnt!, insertInto: DataService.context)
        
        newTicket.setValue(updateUser, forKey: "user")
        newTicket.setValue(updateEvent, forKey: "event")
//        try DataService.context.save()
    }
    
    func unsetTicket(userId: UUID, eventId: UUID) throws {
        let updateUser = try getUserEntityById(userId)
        let updateEvent = try getEventEntityById(eventId)
        
        if !updateUser.eventsArray.contains(updateEvent) {
            throw TicketErrors.ticketNotSet
        }
        
        let deleteTicket = try getTicket(of: updateUser, to: updateEvent)
        
        DataService.context.delete(deleteTicket)

        
//        try DataService.context.save()

    }
    
    func userGotToEvent(_ user: UserEntity?, to event: EventEntity?, isInside: Bool) throws {
        guard let user, let event else { throw TicketErrors.userNoGoThrough }
        let ticket = try getTicket(of: user, to: event)
        
        ticket.is_inside = isInside
    }
    
    func isUserAlreadySetToEvent(userId: UUID, eventId: UUID) -> Bool {
        do {
            let user = try getUserEntityById(userId)
            let event = try getEventEntityById(eventId)
            
            return user.eventsArray.contains(event)
        } catch {
            return false
        }
    }
    
    func isUserInside(_ user: UserEntity, in event: EventEntity) -> Bool {
        do {
            let ticket = try getTicket(of: user, to: event)
            return ticket.is_inside
        } catch {
            return false
        }
    }
    
    private func getAllTickets() throws {
        let ticketRequest = NSFetchRequest<TicketEntity>(entityName: Constants.CoreDataEntities.ticketEntityName)
        ticketRequest.returnsObjectsAsFaults = false
        
        let ticketResult = try DataService.context.fetch(ticketRequest)
        print(ticketResult)
    }
    
    func getTicket(of user: UserEntity, to event: EventEntity) throws -> TicketEntity {
        let ticketRequest = NSFetchRequest<TicketEntity>(entityName: Constants.CoreDataEntities.ticketEntityName)
        ticketRequest.predicate = NSPredicate(format: "user = %@ AND event = %@", user, event)
        ticketRequest.returnsObjectsAsFaults = false
        
        let ticketResult = try DataService.context.fetch(ticketRequest)
        
        guard let ticket = ticketResult.first else { throw TicketErrors.invalidUserId }
        
        return ticket
    }
    
    func getTicketID(of userID: UUID, to eventId: UUID) throws -> UUID? {
        let user = try getUserEntityById(userID)
        let event = try getEventEntityById(eventId)
        
        return try getTicket(of: user, to: event).id
    }
    
    
    private func getEventEntityById(_ eventId: UUID) throws -> EventEntity {
        let eventRequest = NSFetchRequest<EventEntity>(entityName: Constants.CoreDataEntities.eventEntityName)
        eventRequest.predicate = NSPredicate(format: "id = %@", eventId as CVarArg)
        eventRequest.returnsObjectsAsFaults = false
        
        let eventResult = try DataService.context.fetch(eventRequest)
        
        guard let event = eventResult.first else { throw TicketErrors.invalidEventId }
        
        return event
    }
    
    private func getUserEntityById(_ userId: UUID) throws -> UserEntity {
        let request = NSFetchRequest<UserEntity>(entityName: Constants.CoreDataEntities.userEntityName)
        request.predicate = NSPredicate(format: "id = %@", userId as CVarArg)
        request.returnsObjectsAsFaults = false
        
        let result = try DataService.context.fetch(request)
        
        guard let user = result.first else { throw TicketErrors.invalidUserId }
        return user
    }

}
