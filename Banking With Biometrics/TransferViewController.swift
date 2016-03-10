//
//  TransferViewController.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-03-08.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit

class TransferViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var account: Account?
    var accounts: [Account]?
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var invalidAmountLabel: UILabel!
    
    @IBAction func transferTapped(sender: UIButton) {
        let amountString = amountTextField.text
        let amount = NSDecimalNumber(string: amountString)
        if amount == NSDecimalNumber.notANumber() {
            invalidAmountLabel.hidden = false
            return
        }
        invalidAmountLabel.hidden = true
        amountTextField.text = ""
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        let row = pickerView.selectedRowInComponent(0)
        let toAccount = accounts![row]
        Transaction.create(moc, account: toAccount, transactionName: "Transfer From " + account!.name!, amount: amount)
        
        Transaction.create(moc, account: account, transactionName: "Transfer To " + toAccount.name!, amount: amount.decimalNumberByMultiplyingBy(NSDecimalNumber(string: "-1")))
        
        performSegueWithIdentifier("unwindToTransactions", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accounts!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return accounts![row].name
    }
    
}