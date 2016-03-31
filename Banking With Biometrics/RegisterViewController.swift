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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    func loadData(moc:NSManagedObjectContext, user: User?){
        let path = NSBundle.mainBundle().pathForResource("MockData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let accounts = dict!.valueForKey("Accounts") as? NSDictionary
        for (accountName, accountDict) in accounts! {
            let account = Account.create(moc, user: user, accountName: accountName as? String)
            let transactions = accountDict.valueForKey("Transactions")
            for(transaction, amount) in transactions as! NSDictionary {
                Transaction.create(moc, account: account, transactionName: transaction as? String, amount: NSDecimalNumber(string: (amount as? NSNumber)?.stringValue))
            }
        }
    }
}