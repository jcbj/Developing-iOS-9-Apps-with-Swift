//
//  ViewController.swift
//  Calculator
//
//  Created by jiangchao on 16/4/24.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    private var userIsInTheMiddleOfTyping: Bool = false
    private var brain: CalculatorBrin = CalculatorBrin()
    private var savedProgram: CalculatorBrin.PropertyList?
        
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction private func save(sender: AnyObject) {
        savedProgram = brain.program
    }
    
    @IBAction private func restore(sender: AnyObject) {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    //Number
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    //Operation
    @IBAction private func performOperation(sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            
            brain.performOperation(mathematicalSymbol)            
        }
        displayValue = brain.result
    }
}

