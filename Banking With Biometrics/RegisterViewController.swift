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
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if User.doesUsernameExist(managedContext, username: usernameString) {
            return // User already exists in db
        }
        
        User.createInManagedObjectContext(managedContext, username: usernameString, password: passwordString)
        self.performSegueWithIdentifier("unwindAndRegister", sender: self)
    }
}