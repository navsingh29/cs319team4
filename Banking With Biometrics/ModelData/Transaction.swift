//
//  Transaction.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-02-21.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import Foundation
import CoreData


class Transaction: NSManagedObject {

    class func create(moc: NSManagedObjectContext, account: Account?, transactionName: String?, amount: NSDecimalNumber) -> Transaction? {
        let newTransaction = NSEntityDescription.insertNewObjectForEntityForName("Transaction", inManagedObjectContext: moc) as! Transaction
        newTransaction.name = transactionName
        newTransaction.amount = amount
        newTransaction.acount = account
        do {
            try moc.save()
            return newTransaction
        } catch let error as NSError {
            print("Could not create new account \(error), \(error.userInfo)")
        }
        return nil
    }

}
