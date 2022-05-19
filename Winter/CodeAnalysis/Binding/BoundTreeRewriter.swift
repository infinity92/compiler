//
//  BoundTreeRewriter.swift
//  Winter
//
//  Created by Александр Котляров on 22.11.2021.
//

import Foundation

protocol BoundTreeRewriter {
//    func rewrite(statement node: BoundStatement) -> BoundStatement
//    func rewrite(expression node: BoundExpression) -> BoundExpression
}

extension BoundTreeRewriter {
//    func rewrite(statement node: BoundStatement) throws -> BoundStatement {
//        switch node.kind {
//        case .blockStatement:
//            return rewriteBlockstatement(node as! BoundBlockStatement)
//        case .variableDeclatation:
//            return rewriteVariableDeclatation(node as! BoundVariableDeclaration)
//        case .ifStatement:
//            return rewriteIfStatement(node as! BoundIfStatement)
//        case .whileStatement:
//            return rewriteWhileStatement(node as! BoundWhileStatement)
//        case .forStatement:
//            return rewriteForStatement(node as! BoundForStatement)
//        case .expressionStatement:
//            return rewriteExpressionStatement(node as! BoundExpressionStatement)
//        default:
//            throw Exception("Unexpected node: \(node.kind)")
//        }
//    }
//
//    func rewriteBlockstatement(_ node: BoundBlockStatement) -> BoundStatement {
//        return node
//    }
//
//    func rewriteVariableDeclatation(_ node: BoundVariableDeclaration) -> BoundStatement {
//        let initializer = rewrite(expression: node.initializer)
//        if initializer == node.initializer {
//            return node
//        }
//
//        return BoundVariableDeclaration(variable: node.variable, initializer: initializer)
//    }
//
//    func rewriteIfStatement(_ node: BoundIfStatement) -> BoundStatement {
//        let condition = rewrite(expression: node.condition)
//        let thenStatement = rewrite(statement: node.thenStatement)
//        let elseStatement = node.elseStatement == nil ? nil : rewrite(statement: node.elseStatement!)
//        if condition == node.condition && thenStatement == node.thenStatement && elseStatement == node.elseStatement {
//            return node
//        }
//
//        return BoundIfStatement(condition: condition, thenStatement: thenStatement, elseStatement: elseStatement)
//    }
//
//    func rewriteWhileStatement(_ node: BoundWhileStatement) -> BoundStatement {
//        let condition = rewrite(expression: node.condition)
//        let body = rewrite(statement: node.body)
//        if condition == node.condition && body == node.body {
//            return node
//        }
//
//        return BoundWhileStatement(condition: condition, body: body)
//    }
//
//    func rewriteForStatement(_ node: BoundForStatement) -> BoundStatement {
//        let lowerBound = rewrite(expression: node.lowerBound)
//        let upperBound = rewrite(expression: node.upperBound)
//        let body = rewrite(statement: node.body)
//        if lowerBound == node.lowerBound && upperBound == node.upperBound && body == node.body {
//            return node
//        }
//
//        return BoundForStatement(variable: node.variable, lowerBound: lowerBound, upperBound: upperBound, body: body)
//    }
//
//    func rewriteExpressionStatement(_ node: BoundExpressionStatement) -> BoundStatement {
//        let expression = rewrite(expression: node.expression)
//        if expression == node.expression {
//            return node
//        }
//
//        return BoundExpressionStatement(expression: expression)
//    }
//
//    func rewrite(expression node: BoundExpression) throws -> BoundExpression {
//        switch node.kind {
//        case .literalExpression:
//            return rewriteLiteralExpression(node as! BoundLiteralExpression)
//        case .variableExpression:
//            return rewriteVariableExpression(node as! BoundVariableExpression)
//        case .assignmentExpression:
//            return rewriteAssignmentExpression(node as! BoundAssignmentExpression)
//        case .unaryExpression:
//            return rewriteUnaryExpression(node as! BoundUnaryExpression)
//        case .binaryExpression:
//            return rewriteBinaryExpression(node as! BoundBinaryExpression)
//        default:
//            throw Exception("Unexpected node: \(node.kind)")
//        }
//    }
//
//    func rewriteLiteralExpression(_ node: BoundLiteralExpression) -> BoundExpression {
//        return node
//    }
//
//    func rewriteVariableExpression(_ node: BoundVariableExpression) -> BoundExpression {
//        return node
//    }
//
//    func rewriteAssignmentExpression(_ node: BoundAssignmentExpression) -> BoundExpression {
//        let expression = rewrite(expression: node.expression)
//        if expression == node.expression {
//            return node
//        }
//
//        return BoundAssignmentExpression(variable: node.variable, expression: expression)
//    }
//
//    func rewriteUnaryExpression(_ node: BoundUnaryExpression) -> BoundExpression {
//        let operand = rewrite(expression: node.operand)
//        if operand == node.operand {
//            return node
//        }
//
//        return BoundUnaryExpression(op: node.op, operand: operand)
//    }
//
//    func rewriteBinaryExpression(_ node: BoundBinaryExpression) -> BoundExpression {
//        let left = rewrite(expression: node.left)
//        let right = rewrite(expression: node.right)
//        if left == node.left && right == node.right {
//            return node
//        }
//
//        return BoundBinaryExpression(left: left, op: node.op, right: right)
//    }
}
