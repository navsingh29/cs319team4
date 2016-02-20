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
    
    
    @IBAction func onLoginClicked(sender: UIButton) {
        let loginSuccess = areCredentialsCorrect(username.text!, password: password.text!)
        print("Credentials matched? " + String(loginSuccess))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if users.count == 1 {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
    
}