//
//  CustomView.swift
//  Calculator
//
//  Created by Ari on 2021/11/19.
//

import UIKit

class FormulaStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    convenience init(operand: String, `opreator`: String) {
        self.init()
        addLabel(`opreator`)
        addLabel(operand)
    }
    
    convenience init(operand: String) {
        self.init()
        addLabel(operand)
    }
    
    private func setup() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 8
    }
    
    func addLabel(_ text: String) {
        let label: UILabel = {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .title3)
            label.textColor = .white
            label.adjustsFontForContentSizeCategory = true
            label.text = text
            return label
        }()
        self.addArrangedSubview(label)
    }
}
