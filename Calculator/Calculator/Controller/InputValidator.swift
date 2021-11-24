//
//  InputValidator.swift
//  Calculator
//
//  Created by Ari on 2021/11/25.
//

import Foundation

struct InputValidator {
    typealias CalculatorStatus = (currentOperator: String, currentOperand: String, hasCalculated: Bool)
    private var calculatorStatus: CalculatorStatus
    
    init(for inputValues: CalculatorStatus) {
        self.calculatorStatus = inputValues
    }
    var isNotNaN: Bool {
        calculatorStatus.currentOperand != "NaN"
    }
    var isZero: Bool {
        calculatorStatus.currentOperand == "0"
    }
    var isNotZero: Bool {
        calculatorStatus.currentOperand != "0"
    }
    var isNotCalculated: Bool {
        calculatorStatus.hasCalculated == false
    }
    var hasDotNotIncluded: Bool {
        calculatorStatus.currentOperand.contains(".") == false
    }
    var hasMinusNotIncluded: Bool {
        calculatorStatus.currentOperand.contains("-") == false
    }
    
    mutating func setupStatus(by newStatus: CalculatorStatus) {
        self.calculatorStatus = newStatus
    }
    
    func updateOperand(by newOperand: String) -> String {
        isZero ? newOperand : calculatorStatus.currentOperand + newOperand
    }
}
