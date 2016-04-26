//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by jiangchao on 16/4/26.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

import Foundation

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

class CalculatorBrin {
    
    private var accumulator: Double = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "𝝿" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ (op1) in return -op1 }),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation(multiply),
        "÷" : Operation.BinaryOperation({ (op1: Double, op2: Double) -> Double in
            return op1 / op2
        }),
        "+" : Operation.BinaryOperation({ (op1, op2) in return op1 + op2 }),
        "−" : Operation.BinaryOperation(-),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associatedConstantValue):
                accumulator = associatedConstantValue
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        
        if nil != pending {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
        }

    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}