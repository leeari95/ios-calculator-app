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
    private var inputValidator = InputValidator(for: ("", "0", false))
    private var formulas: [String] = []
    
    private var currentOperator: String = "" {
        didSet {
            notifyCurrentState()
            delegate?.updateOperatorLabel(by: currentOperator)
        }
    }
    private var currentOperand: String = "0" {
        didSet {
            notifyCurrentState()
            delegate?.updateOperandLabel(by: currentOperand)
        }
    }
    private var hasCalculated: Bool = false {
        didSet {
            notifyCurrentState()
        }
    }
    private var currentStatus: (String, String, Bool) {
        (currentOperator, currentOperand, hasCalculated)
    }
    private var isCalculationState: Bool {
        currentOperator != ""
    }
    
    func resetStatus() {
        currentOperator = ""
        currentOperand = "0"
        formulas = []
        hasCalculated = false
    }
}

// MARK: Receive Events Related
extension Calculator {
    func operandButtonTap(newOperand: String) {
        let isNotCurrentLabelByZero = (inputValidator.isNotZero || newOperand != "0")
                                      && (inputValidator.isNotZero || newOperand != "00")
        guard isNotCurrentLabelByZero && inputValidator.isNotCalculated else {
            return
        }
        currentOperand = inputValidator.updateOperand(by: newOperand)
    }
    
    func operatorButtonTap(newOperator: String) {
        guard inputValidator.isNotNaN else {
            return
        }
        guard inputValidator.isNotCalculated else {
            startNewCalculation()
            setupNextCalculated(newOperator)
            return
        }
        guard inputValidator.isNotZero else {
            currentOperator = newOperator
            return
        }
        delegate?.addCurrentFormulaStack()
        updateFormulas()
        setupNextCalculated(newOperator)
    }
    
    func allClearButtonTap() {
        resetStatus()
        delegate?.removeFormulaView()
    }
    
    func clearEntryButtonTap() {
        guard inputValidator.isNotZero else {
            return
        }
        guard inputValidator.isNotCalculated else {
            delegate?.removeFormulaView()
            resetStatus()
            return
        }
        currentOperand = "0"
    }
    
    func dotButtonTap() {
        guard inputValidator.isNotCalculated, inputValidator.hasDotNotIncluded else {
            return
        }
        currentOperand += "."
    }
    
    func plusMinusButtonTap() {
        guard inputValidator.isNotCalculated, inputValidator.isNotZero else {
            return
        }
        guard inputValidator.hasMinusNotIncluded else {
            currentOperand.remove(at: currentOperand.startIndex)
            return
        }
        currentOperand = "-" + currentOperand
    }
}

// MARK: Private Methods
extension Calculator {
    private func notifyCurrentState() {
        inputValidator.setupStatus(by: currentStatus)
    }
    
    private func updateFormulas() {
        guard formulas.count > 0 else {
            formulas.append(currentOperand)
            return
        }
        formulas.append(contentsOf: [currentOperator, currentOperand])
    }
    
    private func setupNextCalculated(_ newOperator: String) {
        currentOperand = "0"
        currentOperator = newOperator
    }

    private func startNewCalculation() {
        hasCalculated = false
        delegate?.removeFormulaView()
        delegate?.addCurrentFormulaStack()
    }
}
