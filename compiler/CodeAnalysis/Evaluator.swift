//
//  Evaluator.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

class Evaluator {
    private let root: BoundExpression
    
    init(root: BoundExpression) {
        self.root = root
    }
    
    func evaluate() -> Any {
        return try! evaluateExpression(root)
    }
    
    private func evaluateExpression(_ node: BoundExpression) throws -> Any  {
        if let number = node as? BoundLiteralExpression {
            return number.value
        }
        
        if let unary = node as? BoundUnaryExpression {
            let operand = try! evaluateExpression(unary.operand) as! Int
            if unary.operatorKind == .identity {
                return operand
            } else if unary.operatorKind == .negation {
                    return -operand
            } else {
                throw Exception("Unexpected unary operator \(unary.operatorKind)")
            }
            
            
        }
        
        if let binary = node as? BoundBinaryExpression {
            let left = try! evaluateExpression(binary.left) as! Int
            let right = try! evaluateExpression(binary.right) as! Int
            
            switch binary.operatorKind {
            case .addition:
                return left + right
            case .substruction:
                return left - right
            case .multiplication:
                return left * right
            case .division:
                return left / right
            default:
                throw Exception("Unexpected binary operator \(binary.operatorKind)")
            }
        
        }
        
        throw Exception("Unexpected node \(node.kind)")
    }
}
