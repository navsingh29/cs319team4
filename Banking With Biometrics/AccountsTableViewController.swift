//
//  AccountsTableViewController.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-02-07.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit

class AccountsTableViewController: UITableViewController {
    
    var user: User? = nil
    let accounts = ["Chequing", "Savings", "Credit Card", "Personal Loan", "Mortgage Account", "US Account"]
    
    @IBAction func addIconTapped(sender: UIBarButtonItem) {
        createAlertView()
    }
    
    func createAlertView(){
        let alert: UIAlertController = UIAlertController(title: "Add a New Account", message: nil, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Name of Account"
        })
        
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let moc = appDelegate.managedObjectContext
            Account.create(moc, user: self.user, accountName: textField.text)
             print("TODO: add \(textField.text) to DB")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "Accounts"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "accounts"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        cell.textLabel!.text = accounts[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
        let text = sender?.textLabel??.text
        vc.navigationItem.title = text!
    }
    
}