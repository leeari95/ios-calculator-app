//
//  Calculator.swift
//  Calculator
//
//  Created by Ari on 2021/11/24.
//

import Foundation
import OSLog

protocol CalculatorDelegate {
    func updateOperatorLabel(by newLabelText: String)
    func updateOperandLabel(by newLabelText: String)
    func removeFormulaView()
    func addCurrentFormulaStack()
}

class Calculator {
    var delegate: CalculatorDelegate?
    
}
