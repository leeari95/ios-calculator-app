//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import OSLog

class ViewController: UIViewController {
    // MARK: Property and LifeCycle
    @IBOutlet weak var calculatorScrollView: UIScrollView!
    @IBOutlet weak var calculatorStackView: UIStackView!
    @IBOutlet weak var operandLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet var calculatorButtons: [UIButton]!
    
    private let calculator = Calculator()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.calculator.delegate = self
    }
    
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
    
    private var hasCalculated = false
    
    var isNotZero: Bool {
        currentOperand != "0"
    }
    var isNotCalculated: Bool {
        hasCalculated == false
    }
    var hasDotNotIncluded: Bool {
        currentOperand.contains(".") == false
    }
    var hasMinusNotIncluded: Bool {
        currentOperand.contains("-") == false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func scrollToBottom(_ view: UIScrollView) {
        calculatorScrollView.layoutIfNeeded()
        let bottomOffset = CGPoint(x: 0, y: calculatorScrollView.contentSize.height - calculatorScrollView.frame.height)
        view.setContentOffset(bottomOffset, animated: false)
    }
    
    private func removeComma(_ value: String) -> String {
        guard value.contains(",") else {
            return value
        }
        return value.replacingOccurrences(of: ",", with: "")
    }
}

// MARK: Calculation Result Related
extension ViewController {
    private func setUpNumberFormat(for value: Double) -> String {
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

extension UIStackView {
    var toString: String {
        var inputValues = [String]()
        self.arrangedSubviews.forEach { view in
            guard let formualStackView = view as? FormulaStackView else {
                return
            }
            inputValues.append(contentsOf: formualStackView.element)
        }
        return inputValues.joined(separator: " ")
    }
}

// MARK: Delegate Implementation
extension ViewController: CalculatorDelegate {
    func updateOperatorLabel(by newLabelText: String) {
        currentOperator = newLabelText
    }
    
    func updateOperandLabel(by newLabelText: String) {
        currentOperand = newLabelText
    }
    
    func removeFormulaView() {
        calculatorStackView.subviews.forEach{
            $0.removeFromSuperview()
        }
    }
    
    func addCurrentFormulaStack() {
        let formulaStackView = addFormulaStackView(operand: currentOperand, operator: currentOperator)
        calculatorStackView.addArrangedSubview(formulaStackView)
    }
}
