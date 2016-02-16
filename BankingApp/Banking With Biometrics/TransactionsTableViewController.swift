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
    
    let transactions = [-30.10,-4999.05,18500.50,-850, 8500, -500, -890.99, -800, -17999.99]
    let transactionNames = ["Gas", "UBC Bookstore", "Google Inc.", "Apple Store", "Freelance Work", "Microsoft Store", "Best Buy", "Landlord", "UBC Tuition"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var sum = 0.0
        for i in transactions {
            sum += i
        }
        balance.text = "$"+String(format:"%.2f", sum)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        cell.textLabel?.text = transactionNames[indexPath.row]
        cell.detailTextLabel?.text = String(transactions[indexPath.row])
        return cell
    }
    
    
}