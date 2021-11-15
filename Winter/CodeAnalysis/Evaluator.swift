//
//  Evaluator.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

class Evaluator {
    private let root: BoundExpression
    //private var variables: [VariableSymbol: Any]
    
    init(root: BoundExpression) {
        self.root = root
        //self.variables = variables
    }
    
    func evaluate() -> Any {
        return try! evaluateExpression(root)
    }
    
    private func evaluateLiteralExpression(_ number: BoundLiteralExpression) -> Any {
        return number.value
    }
    
    private func evaluateVariableExpression(_ variable: BoundVariableExpression) -> Any {
        return variables[variable.variable]!
    }
    
    private func evaluateAssignmentExpression(_ assign: BoundAssignmentExpression) -> Any {
        let value = try! evaluateExpression(assign.expression)
        variables[assign.variable] = value
        return value
    }
    
    private func evaluateBinaryExpression(_ binary: BoundBinaryExpression) throws -> Any {
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
            return try! equalExpressions(left, right)
        case .notEquals:
            return try! !equalExpressions(left, right)
        default:
            throw Exception("Unexpected binary operator \(binary.op.kind)")
        }
    }
    
    private func equalExpressions(_ expression1: Any, _ expression2: Any) throws -> Bool {
        if let left = expression1 as? Bool, let right = expression2 as? Bool {
            return left == right
        } else if let left = expression1 as? Int, let right = expression2 as? Int {
            return left == right
        } else {
            throw Exception("Could not cast value of type")
        }
    }
    
    private func evaluateUnaryExpression(_ unary: BoundUnaryExpression) throws -> Any {
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
    
    private func evaluateExpression(_ node: BoundExpression) throws -> Any  {
        
        switch node.kind {
        case .literalExpression:
            return evaluateLiteralExpression(node as! BoundLiteralExpression)
        case .variableExpression:
            return evaluateVariableExpression(node as! BoundVariableExpression)
        case .assignmentExpression:
            return evaluateAssignmentExpression(node as! BoundAssignmentExpression)
        case .unaryExpression:
            return try! evaluateUnaryExpression(node as! BoundUnaryExpression)
        case .binaryExpression:
            return try! evaluateBinaryExpression(node as! BoundBinaryExpression)
        default:
            throw Exception("Unexpected node \(node.kind)")
        }
    }
}
