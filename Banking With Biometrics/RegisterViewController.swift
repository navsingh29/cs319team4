//
//  RegisterViewController.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-02-20.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController : UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func onRegisterTapped(sender: UIButton) {
        
        let usernameString = username.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let passwordString = password.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        
        if usernameString.isEmpty || passwordString.isEmpty {
            return
        }
        
        if areCredentialsCorrect(usernameString, password: passwordString) {
            return // User already exists in db
        }
        
        addUserToDB(usernameString, password: passwordString)
        self.performSegueWithIdentifier("unwindAndRegister", sender: self)
    }
    
    func addUserToDB(user: String, password: String) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let newItem = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedContext) as! User
        newItem.username = user
        newItem.password = password
    }
    
    func areCredentialsCorrect(username: String, password: String) -> Bool {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let users = results as! [NSManagedObject]
            print("Number of users found: \(users.count)")
            if users.count == 1 {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
}