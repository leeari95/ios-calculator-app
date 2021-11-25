//
//  UIStackView+extension.swift
//  Calculator
//
//  Created by Ari on 2021/11/25.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
