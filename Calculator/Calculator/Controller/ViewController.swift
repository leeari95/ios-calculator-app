//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    // MARK: Property and LifeCycle
    @IBOutlet weak var calculatorScrollView: UIScrollView!
    @IBOutlet weak var calculatorStackView: UIStackView!
    @IBOutlet weak var operandLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet var calculatorButtons: [UIButton]!
    
    private let calculator = Calculator()
    
    private var currentOperand: String {
        get {
            guard let operand = operandLabel.text else {
                return ""
            }
            return operand
        }
        set {
            operandLabel.text = newValue
        }
    }
    private var currentOperator: String {
        get {
            guard let `operator` = operatorLabel.text else {
                return ""
            }
            return `operator`
        }
        set {
            operatorLabel.text = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculator.delegate = self
        calculator.resetStatus()
        removeFormulaView()
    }
    
    func setupButtons() {
        calculatorButtons.forEach { button in
            button.layoutIfNeeded()
            button.layer.cornerRadius = button.bounds.width / 2
        }
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        setupButtons()
    }
}

// MARK: IBAction
extension ViewController {
    @IBAction func operandButtonTapped(_ sender: UIButton) {
        guard let newOperand = sender.titleLabel?.text else {
            return
        }
        calculator.operandButtonTap(newOperand: newOperand)
    }
    
    @IBAction func operatorButtonTapped(_ sender: UIButton) {
        guard let newOperator = sender.titleLabel?.text else {
            return
        }
        calculator.operatorButtonTap(newOperator: newOperator)
    }
    
    @IBAction func clearEntryButtonTapped(_ sender: UIButton) {
        calculator.clearEntryButtonTap()
    }
    
    @IBAction func allClearButtonTapped(_ sender: UIButton) {
        calculator.allClearButtonTap()
    }
    
    @IBAction func dotButtonTapped(_ sender: UIButton) {
        calculator.dotButtonTap()
    }
    
    @IBAction func plusMinusButtonTapped(_ sender: UIButton) {
        calculator.plusMinusButtonTap()
    }
    
    @IBAction func equalButtonTapped(_ sender: UIButton) {
        calculator.equalButtonTap()
    }
}

// MARK: Formula Stack View Related
extension ViewController {
    private func addFormulaStackView(operand: String, operator: String) -> UIStackView {
        let formulaStackView = FormulaStackView()
        guard calculatorStackView.subviews.count > 0 else {
            formulaStackView.addLabel(operand)
            return formulaStackView
        }
        formulaStackView.addLabel(`operator`)
        formulaStackView.addLabel(operand)
        return formulaStackView
    }
    
    private func scrollToBottom() {
        calculatorScrollView.layoutIfNeeded()
        let bottomOffset = CGPoint(x: 0, y: calculatorScrollView.contentSize.height
                                            - calculatorScrollView.frame.height)
        calculatorScrollView.setContentOffset(bottomOffset, animated: false)
    }
    
    func setUpNumberFormat(for value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumSignificantDigits = 20
        numberFormatter.roundingMode = .up
        guard let formatterNumber = numberFormatter.string(for: value) else {
            return value.description
        }
        guard formatterNumber.count < 26 else {
            return formatterNumber.map{ $0.description }[0]
        }
        return formatterNumber
    }
}

// MARK: Delegate Implementation
extension ViewController: CalculatorDelegate {
    func updateOperatorLabel(by newLabelText: String) {
        currentOperator = newLabelText
    }
    
    func updateOperandLabel(by newLabelText: String) {
        guard let doubleValue = Double(newLabelText.replacingOccurrences(of: ",", with: "")) else {
            return
        }
        guard doubleValue != 0 else {
            currentOperand = newLabelText
            return
        }
        guard newLabelText.last != "." else {
            currentOperand = setUpNumberFormat(for: doubleValue) + "."
            return
        }
        currentOperand = setUpNumberFormat(for: doubleValue)
    }
    
    func removeFormulaView() {
        calculatorStackView.removeAllArrangedSubviews()
    }
    
    func addCurrentFormulaStack() {
        let formulaStackView = addFormulaStackView(operand: currentOperand, operator: currentOperator)
        calculatorStackView.addArrangedSubview(formulaStackView)
        scrollToBottom()
    }
}
