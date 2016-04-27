//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by jiangchao on 16/4/26.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

import Foundation

//演示函数作为参数传递：可以使用闭包
func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

class CalculatorBrin {
    
    typealias PropertyList = AnyObject

    //Nested Type
    //关联不同值
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    //Field
    private var pending: PendingBinaryOperationInfo?
    private var accumulator: Double = 0.0
    private var internalProgram = [AnyObject]()
    
    //Private Property
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ (op1) in return -op1 }), //省略参数类型及返回值类型
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation(multiply), //函数名作为参数传递
        "÷" : Operation.BinaryOperation({
            (op1: Double, op2: Double) -> Double in
            return op1 / op2
        }),  //完整的闭包模版
        "+" : Operation.BinaryOperation({ $0 + $1 }),//省略参数，使用默认参数，($0, $1) in return $0 + $1 报错
        "−" : Operation.BinaryOperation(-),//操作符已经重载，实际就是函数，所以可以直接传递操作符
        "=" : Operation.Equals
    ]
    
    //Internal Property
    var result: Double {
        get {
            return accumulator
        }
    }
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
            
        }
    }
    
    //Internal Methods
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        
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
    
    //Private Methods
    private func executePendingBinaryOperation() {
        
        if nil != pending {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }

    }
    
    private func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }

}