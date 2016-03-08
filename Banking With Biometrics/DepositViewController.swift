//
//  DepositViewController.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-03-08.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit

class DepositViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var user: User?
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var invalidAmountLabel: UILabel!
    
    @IBAction func depositTapped(sender: UIButton) {
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
        let accounts = user!.accounts
        let accountsArray = accounts!.allObjects as? [Account]
        let account = accountsArray![row]
        Transaction.create(moc, account: account, transactionName: "Cheque Deposited", amount: amount)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        pickerView.reloadAllComponents()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return user!.accounts!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let accounts = user!.accounts
        let accountsArray = accounts!.allObjects as? [Account]
        return accountsArray![row].name
    }
    
    
}