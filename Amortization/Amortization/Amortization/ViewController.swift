//
//  ViewController.swift
//  Amortization
//
//  Created by Baid, Arhat Pushparaj on 2/13/18.
//  Copyright © 2018 Baid, Arhat Pushparaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
  
    @IBOutlet weak var txtLoanAmount: UITextField!
    @IBOutlet weak var txtInterestRate: UITextField!
    @IBOutlet weak var txtExtMonthlyPayment: UITextField!
    @IBOutlet weak var txtAnnualPayment: UITextField!
    @IBOutlet weak var txtTotalAmount: UILabel!
    @IBOutlet weak var txtTotalInterest: UILabel!
    @IBOutlet weak var txtTable: UITextView!
    @IBOutlet weak var segYears: UISegmentedControl!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalInterest: UILabel!
    @IBOutlet weak var lblError: UILabel!
    
    var initialBalance : Double = 0.0
    var interestRate : Double = 0.0
    var totalMonths : Double = 0.0
    var totalInterest : Double = 0.0
    var extMonthly : Double = 0.0
    var extAnnual : Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblError.isHidden = true
        lblError.text = ""
        
        setViewHidden(isHidden : true)
        
        
        self.txtLoanAmount.keyboardType = UIKeyboardType.decimalPad
        self.txtInterestRate.keyboardType = UIKeyboardType.decimalPad
        self.txtExtMonthlyPayment.keyboardType = UIKeyboardType.decimalPad
        self.txtAnnualPayment.keyboardType = UIKeyboardType.decimalPad
        
        
        txtLoanAmount.becomeFirstResponder()
        self.txtLoanAmount.delegate = self
        self.txtInterestRate.delegate = self
        self.txtExtMonthlyPayment.delegate = self
        self.txtAnnualPayment.delegate = self
        self.txtTable.delegate = self
    }
    
    @IBAction func btnClear(_ sender: UIButton) {
        setViewHidden(isHidden: true)
        
        lblError.isHidden = true
        lblError.text = ""
        
        txtLoanAmount.text = ""
        txtInterestRate.text = ""
        txtExtMonthlyPayment.text = ""
        txtAnnualPayment.text = ""
        txtTable.text = ""
    }
    
    
    
    @IBAction func btnCalculate(_ sender: UIButton) {
        lblError.isHidden = true
        lblError.text = ""
        
        txtLoanAmount.resignFirstResponder()
        txtInterestRate.resignFirstResponder()
        txtExtMonthlyPayment.resignFirstResponder()
        txtAnnualPayment.resignFirstResponder()
        
        //LoanAmount
        if let text = txtLoanAmount.text, !text.isEmpty {
            initialBalance =  (txtLoanAmount.text! as NSString).doubleValue
        }else {
            lblError.isHidden = false
            lblError.text = "Please enter the loan amount!!!"
            return
        }
        
        //Interest
        if let text = txtInterestRate.text, !text.isEmpty {
            interestRate = (txtInterestRate.text! as NSString).doubleValue
        }else {
            lblError.isHidden = false
            lblError.text = "Please enter the interest rate!!!"
            return
        }
        
        //Extra Monthly Amount
        if let text = txtExtMonthlyPayment.text, text.isEmpty {
            extMonthly = 0.0
        }else{
            extMonthly = (txtExtMonthlyPayment.text! as NSString).doubleValue
        }
        
        //Extra Annual Amonut
        if let text = txtAnnualPayment.text, text.isEmpty {
            extAnnual = 0.0
        }else{
            extAnnual = (txtAnnualPayment.text! as NSString).doubleValue
        }
        
        
        totalMonths = ((segYears.titleForSegment(at: segYears.selectedSegmentIndex))! as NSString).doubleValue  * 12.00
        
        calculateAmortizationValue()
    }
    
    
    func calculateAmortizationValue() {
        
        let interestPerMonth = interestRate / 12.00
        var balance = initialBalance
        let payment : Double = (balance * interestPerMonth * pow((1.00 + interestPerMonth), totalMonths)) / (pow((1.00 + interestPerMonth), totalMonths) - 1.00)
        var paymnetNumber = 1
        var tableVlaue : String = "Payment#    PreviousBalance    Interest    Principle    NewBalance\n----------    ----------------     --------    ---------    ----------\n"
        
        while balance > 0.0001 {
            
            let calInterest : Double = interestPerMonth * balance
            let calPrinciple : Double = payment - calInterest
            let calNewBalance : Double = balance - calPrinciple
            
            tableVlaue.append(String(paymnetNumber))
            tableVlaue.append(countSpaces(value: String(paymnetNumber), headerPosition: 0))
            
            tableVlaue.append(String(format: "%.2f",balance))
            tableVlaue.append(countSpaces(value: String(format: "%.2f",balance), headerPosition: 1))
            
            tableVlaue.append(String(format: "%.2f",calInterest))
            tableVlaue.append(countSpaces(value: String(format: "%.2f",calInterest), headerPosition: 2))
            
            tableVlaue.append(String(format: "%.2f",calPrinciple))
            tableVlaue.append(countSpaces(value: String(format: "%.2f",calPrinciple), headerPosition: 3))
            
            tableVlaue.append(String(format: "%.2f",calNewBalance))
            tableVlaue.append("\n")
            
            
            paymnetNumber += 1
            balance = balance - (payment + extMonthly) + calInterest
            totalInterest += calInterest
            if paymnetNumber % 12 == 0 {
                balance -= extAnnual
            }
        }
        
        txtTotalInterest.text = String(format: "%.2f", totalInterest)
        txtTotalAmount.text = String(format: "%.2f", totalInterest + initialBalance)
        txtTable.text = tableVlaue
        
        setViewHidden(isHidden : false)
        
    }
    
    
    
    func countSpaces(value : String, headerPosition : Int) -> String {
        var header = ""
        
        if headerPosition == 0 {
            header = "Payment#"
        }else if headerPosition == 1 {
            header = "PreviousBalance"
        }else if headerPosition == 2 {
            header = "Interest"
        }else {
            header = "Principle"
        }
        
        var spaces: String = ""
        let loopCount = header.count - value.count + 6 //The sapce between the columns
        
        for _ in 0...loopCount {
            spaces.append(" ")
        }
        
        return spaces
    }
    
    
    func setViewHidden(isHidden : Bool){
        self.txtTotalInterest.isHidden = isHidden
        self.txtTotalAmount.isHidden = isHidden
        self.txtTotalInterest.isHidden = isHidden
        self.lblTotalAmount.isHidden = isHidden
        self.lblTotalInterest.isHidden = isHidden
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //To bring down the keyboard om return keyword
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtLoanAmount {
            txtLoanAmount.resignFirstResponder()
            txtInterestRate.becomeFirstResponder()
        } else if textField == self.txtInterestRate {
            txtInterestRate.resignFirstResponder()
            txtExtMonthlyPayment.becomeFirstResponder()
        } else if textField == self.txtExtMonthlyPayment {
            txtExtMonthlyPayment.resignFirstResponder()
            txtAnnualPayment.becomeFirstResponder
        } else if textField == self.txtAnnualPayment {
            txtAnnualPayment.resignFirstResponder()
        }
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtLoanAmount.resignFirstResponder()
        txtInterestRate.resignFirstResponder()
        txtExtMonthlyPayment.resignFirstResponder()
        txtAnnualPayment.resignFirstResponder()
        txtTable.resignFirstResponder()
        view.endEditing(true)
    }


}

