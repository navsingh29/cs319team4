//
//  AccountsTableViewController.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-02-07.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit

class TransactionsTableViewController: UITableViewController {
    
    @IBOutlet weak var balance: UILabel!
    
    var account: Account?
    var accounts: [Account]?
    //let transactions = [-30.10,-4999.05,18500.50,-850, 8500, -500, -890.99, -800, -17999.99]
    //let transactionNames = ["Gas", "UBC Bookstore", "Google Inc.", "Apple Store", "Freelance Work", "Microsoft Store", "Best Buy", "Landlord", "UBC Tuition"]
    
    @IBAction func cancelUnwindToTransactionsTableViewController(segue:UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var sum = NSDecimalNumber(double: 0.0)
        for t in account!.transactions! {
            sum = (t as! Transaction).amount!.decimalNumberByAdding(sum)
        }
        balance.text = "$" + sum.stringValue
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return account!.transactions!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        let transactions = account?.transactions?.allObjects as! [Transaction]
        cell.textLabel?.text = transactions[indexPath.row].name
        cell.detailTextLabel?.text = transactions[indexPath.row].amount?.stringValue
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "transactionToTransfer" {
            let vc = segue.destinationViewController as! TransferViewController
            vc.account = account
            vc.accounts = accounts
        }
    }
    
}