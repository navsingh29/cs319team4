//
//  AccountsTableViewController.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-02-07.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit

class AccountsTableViewController: UITableViewController {
    
    var user: User?
    
    @IBAction func addIconTapped(sender: UIBarButtonItem) {
        createAlertView()
    }
    
    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let storyboard: UIStoryboard = appDelegate.window!.rootViewController!.storyboard!
        let firstViewController: UIViewController = storyboard.instantiateInitialViewController()!
        appDelegate.window?.rootViewController = firstViewController
        
        createLogoutAlert()
    }
    
    func createLogoutAlert() {
        let alert: UIAlertController = UIAlertController(title: "You have successfully logged out", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
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
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
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
        return user!.accounts!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "accounts"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        let accounts = user!.accounts
        let accountsArray = accounts!.allObjects as? [Account]
        let account = accountsArray![indexPath.row]
        cell.textLabel!.text = account.name
        cell.tag = indexPath.row
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
        let text = sender?.textLabel??.text
        vc.navigationItem.title = text!
        
        if segue.identifier == "accountsToTransactions" {
            let transactionTVC = segue.destinationViewController as! TransactionsTableViewController
            let accounts = user!.accounts
            let accountsArray = accounts!.allObjects as? [Account]
            let index = sender!.tag!
            let account = accountsArray![index]
            transactionTVC.account = account
            transactionTVC.accounts = accountsArray
        }
    }
    
}