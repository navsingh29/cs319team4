//
//  Account.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-02-21.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import Foundation
import CoreData


class Account: NSManagedObject {

    class func create(moc: NSManagedObjectContext, user: User?, accountName: String?) -> Account? {
        let newAccount = NSEntityDescription.insertNewObjectForEntityForName("Account", inManagedObjectContext: moc) as! Account
        newAccount.user = user
        newAccount.name = accountName
        do {
            try moc.save()
            return newAccount
        } catch let error as NSError {
            print("Could not create new account \(error), \(error.userInfo)")
        }
        return nil
    }

}
