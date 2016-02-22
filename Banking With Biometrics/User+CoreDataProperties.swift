//
//  User+CoreDataProperties.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-02-20.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var password: String?
    @NSManaged var username: String?

    class func createInManagedObjectContext(moc: NSManagedObjectContext, username: String, password: String) -> User? {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! User
        newItem.username = username
        newItem.password = password
        do {
            try moc.save()
            return newItem
        } catch let error as NSError {
            print("Could not create new user \(error), \(error.userInfo)")
        }
        return nil
    }
    
    class func doesUsernameExist(moc: NSManagedObjectContext, username: String) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            let users = results as! [User]
            if users.count > 0 {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
    
    class func validateUser(moc: NSManagedObjectContext, username: String, password: String) -> User? {
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            let users = results as! [User]
            return users.first
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
}
