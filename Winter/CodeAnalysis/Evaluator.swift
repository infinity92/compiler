//
//  Evaluator.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

class Evaluator {
    private let root: BoundStatement
    private var lastValue: Any?
    
    init(root: BoundStatement) {
        self.root = root
    }
    
    func evaluate() -> Any {
        
        try! evaluateStatement(root)
        return lastValue!
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
        case .less:
            return (left as! Int) < (right as! Int)
        case .lessOrEquals:
            return (left as! Int) <= (right as! Int)
        case .greater:
            return (left as! Int) > (right as! Int)
        case .greaterOrEquals:
            return (left as! Int) >= (right as! Int)
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
    
    private func evaluateStatement(_ node: BoundStatement) throws  {
        
        switch node.kind {
        case .blockStatement:
            evaluateBlockStatement(node as! BoundBlockStatement)
        case .expressionStatement:
            evaluateExpressionStatement(node as! BoundExpressionStatement)
        case .variableDeclatation:
            evaluateVariableDeclaration(node as! BoundVariableDeclaration)
        case .ifStatement:
            evaluateIfStatement(node as! BoundIfStatement)
        case .whileStatement:
            evaluateWhileStatement(node as! BoundWhileStatement)
        case .forStatement:
            evaluateForStatement(node as! BoundForStatement)
        default:
            throw Exception("Unexpected node \(node.kind)")
        }
    }
    
    private func evaluateForStatement(_ node: BoundForStatement) {
        let lowerBound = try! evaluateExpression(node.lowerBound) as! Int
        let upperBound = try! evaluateExpression(node.upperBound) as! Int
        
        for i in lowerBound...upperBound {
            variables[node.variable] = i
            try! evaluateStatement(node.body)
        }
    }
    
    private func evaluateWhileStatement(_ node: BoundWhileStatement) {
        while (try! evaluateExpression(node.condition) as! Bool) {
            try! evaluateStatement(node.body)
        }
    }
    
    private func evaluateIfStatement(_ node: BoundIfStatement) {
        let condition = try! evaluateExpression(node.condition) as! Bool
        if condition {
            try! evaluateStatement(node.thenStatement)
        } else if node.elseStatement != nil {
            try! evaluateStatement(node.elseStatement!)
        }
    }
    
    private func evaluateVariableDeclaration(_ node: BoundVariableDeclaration) {
        let value = try! evaluateExpression(node.initializer)
        variables[node.variable] = value
        lastValue = value
    }
    
    private func evaluateBlockStatement(_ node: BoundBlockStatement) {
        node.statements.forEach { statement in
            try! evaluateStatement(statement)
        }
    }
    
    private func evaluateExpressionStatement(_ node: BoundExpressionStatement) {
        lastValue = try! evaluateExpression(node.expression)
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
