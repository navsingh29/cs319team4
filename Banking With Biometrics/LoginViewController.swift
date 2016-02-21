//
//  LoginViewController.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-02-03.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var usernameText: String = ""
    var passwordText: String = ""
    
    @IBAction func onLoginClicked(sender: UIButton) {
        usernameText = username.text!
        passwordText = password.text!
        let loginSuccess = areCredentialsCorrect(usernameText, password: passwordText)
        print("Login success: \(String(loginSuccess))")
    }
    
    @IBAction func register(segue:UIStoryboardSegue) {
    }
    
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "loginSegue" {
            let loginSuccess = areCredentialsCorrect(username.text!, password: password.text!)
            return loginSuccess
        }
        return true
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