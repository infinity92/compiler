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
    
    func evaluate() -> Int {
        return try! evaluateExpression(root)
    }
    
    private func evaluateExpression(_ node: BoundExpression) throws -> Int  {
        if let literal = node as? BoundLiteralExpression {
            return literal.value as! Int
        }
        
        if let unary = node as? BoundUnaryExpression {
            let operand = try! evaluateExpression(unary.operand)
            if unary.operatorKind == .identity {
                return operand
            } else if unary.operatorKind == .negation {
                    return -operand
            } else {
                throw Exception("Unexpected unary operator \(unary.operatorKind)")
            }
            
            
        }
        
        if let binary = node as? BoundBinaryExpression {
            let left = try! evaluateExpression(binary.left)
            let right = try! evaluateExpression(binary.right)
            
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
