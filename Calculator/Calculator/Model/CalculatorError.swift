//
//  QueueError.swift
//  Calculator
//
//  Created by Ari on 2021/11/10.
//

import Foundation

enum CalculatorError: Error {
    case queueNotFound
    case wrongOperator
    case wrongOperand
    case notNumber
    
    var description: String {
        switch self {
        case .queueNotFound:
            return "큐가 비어있습니다."
        case .wrongOperator:
            return "잘못된 연산자입니다."
        case .wrongOperand:
            return "잘못된 숫자입니다."
        case .notNumber:
            return "NaN"
        }
    }
}