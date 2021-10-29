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
            let operand = try! evaluateExpression(unary.operand)
            
            switch unary.op.kind {
            case .identity:
                return operand as! Int
            case .negation:
                return -(operand as! Int)
            case .logicalNagarion:
                return !(operand as! Bool)
            default:
                throw Exception("Unexpected unary operator \(unary.op.kind)")
            }
        }
        
        if let binary = node as? BoundBinaryExpression {
            let left = try! evaluateExpression(binary.left)
            let right = try! evaluateExpression(binary.right)
            
            switch binary.op.kind {
            case .addition:
                return (left as! Int) + (right as! Int)
            case .substruction:
                return (left as! Int) - (right as! Int)
            case .multiplication:
                return (left as! Int) * (right as! Int)
            case .division:
                return (left as! Int) / (right as! Int)
            case .logicalAnd:
                return (left as! Bool) && (right as! Bool)
            case .logicalOr:
                return (left as! Bool) || (right as! Bool)
            case .equals:
                if let left = left as? Bool, let right = right as? Bool {
                    return left == right
                } else if let left = left as? Int, let right = right as? Int {
                    return left == right
                } else {
                    throw Exception("Could not cast value of type")
                }
            case .notEquals:
                if let left = left as? Bool, let right = right as? Bool {
                    return left != right
                } else if let left = left as? Int, let right = right as? Int {
                    return left != right
                } else {
                    throw Exception("Could not cast value of type")
                }
            default:
                throw Exception("Unexpected binary operator \(binary.op.kind)")
            }
        
        }
        
        throw Exception("Unexpected node \(node.kind)")
    }
}
