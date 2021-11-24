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
        removeFormulaLabel()
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

// MARK: IBAction method
extension ViewController {
    @IBAction func operandButtonTapped(_ sender: UIButton) {
        guard let newOperand = sender.titleLabel?.text else {
            return
        }
        calculator.operandButtonTap(newOperand: newOperand)
    }
    
    @IBAction func operatorButtonTapped(_ sender: UIButton) {
        guard currentOperand != "NaN",
              let newOperator = sender.titleLabel?.text else {
            return
        }
        guard isNotCalculated else {
            startNewCalculation()
            updateCurrentLabel(newOperator)
            return
        }
        guard isNotZero else {
            operatorLabel.text = sender.titleLabel?.text
            return
        }
        addCurrentFormulaStack()
        updateCurrentLabel(newOperator)
        scrollToBottom(calculatorScrollView)
    }
    
    @IBAction func clearEntryButtonTapped(_ sender: UIButton) {
        guard isNotZero || currentOperand != "" else {
            return
        }
        guard isNotCalculated else {
            hasCalculated = false
            removeFormulaView()
            removeFormulaLabel()
            return
        }
        currentOperand = "0"
    }
    
    @IBAction func allClearButtonTapped(_ sender: UIButton) {
        removeFormulaLabel()
        removeFormulaView()
        hasCalculated = false
    }
    
    @IBAction func dotButtonTapped(_ sender: UIButton) {
        guard isNotCalculated, hasDotNotIncluded,
              let newOperand = sender.titleLabel?.text else {
            return
        }
        currentOperand = currentOperand + newOperand
    }
    
    @IBAction func plusMinusButtonTapped(_ sender: UIButton) {
        guard isNotCalculated, isNotZero else {
            return
        }
        guard hasMinusNotIncluded else {
            currentOperand.remove(at: currentOperand.startIndex)
            return
        }
        currentOperand = "-" + currentOperand
    }
    
    @IBAction func equalButtonTapped(_ sender: UIButton) {
        guard isNotCalculated else {
            return
        }
        addCurrentFormulaStack()
        var formula = ExpressionParser.parse(from: calculatorStackView.toString)
        do {
            let calcuatorResult = try formula.result()
            currentOperand = setUpNumberFormat(for: calcuatorResult)
        } catch let error as CalculatorError {
            switch error {
            case .isNaN:
                currentOperand = error.failureReason ?? "NaN"
                hasCalculated = true
                return
            case .queueNotFound:
                os_log(.error, log: .error, "%@", error.errorDescription ?? error.localizedDescription)
                debugPrint(error.errorDescription ?? error.localizedDescription)
                removeFormulaView()
                return
            default:
                os_log(.error, log: .error, "%@", error.errorDescription ?? error.localizedDescription)
                return
            }
        } catch let error {
            os_log(.error, log: .error, "%@", error.localizedDescription)
        }
        currentOperator = ""
        hasCalculated = true
    }
}

// MARK: Formula Stack View Related
extension ViewController {
    private func startNewCalculation() {
        hasCalculated = false
        removeFormulaView()
        currentOperand = currentOperand
        addCurrentFormulaStack()
    }

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

// MARK: Label Initialization Related
extension ViewController {
    private func updateCurrentLabel(_ newOperator: String) {
        currentOperand = "0"
        currentOperator = newOperator
    }
    
    private func removeFormulaLabel() {
        currentOperand = "0"
        currentOperator = ""
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
    }
    
    func updateOperandLabel(by newLabelText: String) {
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
