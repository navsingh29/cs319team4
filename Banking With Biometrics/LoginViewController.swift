//
//  LoginViewController.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-02-03.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit
import CoreData
import BBLibrary

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordMismatch: UILabel!
    
    var user: User?
    
    @IBAction func onLoginClicked(sender: UIButton) {
        let usernameText = username.text!
        let passwordText = password.text!
        let loginSuccess = areCredentialsCorrect(usernameText, password: passwordText)
        if !loginSuccess {
            passwordMismatch.hidden = false
        }
        
        if let library = BBLibrary.get() {
            library.setUserID(usernameText)
        }
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSegue" {
            let tab = segue.destinationViewController as! UITabBarController
            let nav = tab.viewControllers![0] as! UINavigationController
            let accounts = nav.topViewController as! AccountsTableViewController
            accounts.user = user
            
            let deposit = tab.viewControllers![1] as! DepositViewController
            deposit.user = user
        }
    }
    
    func areCredentialsCorrect(username: String, password: String) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        user = User.validateUser(managedContext, username: username, password: password)
        return  user != nil
    }
    
}