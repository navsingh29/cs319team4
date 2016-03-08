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
    @IBOutlet weak var usernameTaken: UILabel!

    @IBAction func onRegisterTapped(sender: UIButton) {

        let usernameString = username.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let passwordString = password.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        
        if usernameString.isEmpty || passwordString.isEmpty {
            return
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if User.doesUsernameExist(managedContext, username: usernameString) {
            usernameTaken.hidden = false
            return // User already exists in db
        }
        
        let user = User.createInManagedObjectContext(managedContext, username: usernameString, password: passwordString)
        loadData(managedContext, user: user)
        self.performSegueWithIdentifier("unwindAndRegister", sender: self)
    }
    
    
    func loadData(moc:NSManagedObjectContext, user: User?){
        let path = NSBundle.mainBundle().pathForResource("MockData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let accounts = dict!.valueForKey("Accounts") as? NSDictionary
        for (accountName, accountDict) in accounts! {
            let account = Account.create(moc, user: user, accountName: accountName as? String)
            //print(accountName)
            let transactions = accountDict.valueForKey("Transactions")
            for(transaction, amount) in transactions as! NSDictionary {
                //print((transaction as! String) + " " + (amount as! NSNumber).stringValue)
                Transaction.create(moc, account: account, transactionName: transaction as? String, amount: NSDecimalNumber(string: (amount as? NSNumber)?.stringValue))
            }
        }
    }
    
    /*
    func loadData() {
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("GameData", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                println("Bundle GameData.plist file is --> \(resultDictionary?.description)")
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
                println("copy")
            } else {
                println("GameData.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            println("GameData.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        println("Loaded GameData.plist file is --> \(resultDictionary?.description)")
        var myDict = NSDictionary(contentsOfFile: path)
        if let dict = myDict {
            //loading values
            bedroomFloorID = dict.objectForKey(BedroomFloorKey)!
            bedroomWallID = dict.objectForKey(BedroomWallKey)!
            //...
        } else {
            println("WARNING: Couldn't create dictionary from GameData.plist! Default values will be used!")
        }
    }
*/
}