//
//  Binder.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

class Binder {
    private(set) var diagnostics: [String] = []
    
    func bindExpression(syntax: ExpressionSyntax) throws -> BoundExpression {
        switch syntax.kind {
        case .unaryExpression:
            return bindUnaryExpression(syntax as! UnaryExpressionSyntax)
        case .binaryExpression:
            return bindBinaryExpression(syntax as! BinaryExpressionSyntax)
        case .literalExpression:
            return bindLiteralExpression(syntax as! LiteralExpressionSyntax)
        default:
            throw Exception("Unxpected syntax \(syntax.kind)")
        }
    }
    
    private func bindBinaryExpression(_ syntax: BinaryExpressionSyntax) -> BoundExpression {
        let boundLeft = try! bindExpression(syntax: syntax.left)
        let boundRight = try! bindExpression(syntax: syntax.right)
        guard let boundOperator = BoundBinaryOperator.bind(syntaxKind: syntax.operatorToken.kind, leftType: boundLeft.expressionType, rightType: boundRight.expressionType)else {
            diagnostics.append("Binary operator '\(String(describing: syntax.operatorToken.text))' is not defined for type \(boundLeft.expressionType) and \(boundRight.expressionType)")
            return boundLeft
        }
        return BoundBinaryExpression(left: boundLeft, op: boundOperator, right: boundRight)
    }
    
    private func bindUnaryExpression(_ syntax: UnaryExpressionSyntax) -> BoundExpression {
        let boundOperand = try! bindExpression(syntax: syntax.operand)
        guard let boundOperator = BoundUnaryOperator.bind(syntaxKind: syntax.operatorToken.kind, operandType: boundOperand.expressionType) else {
            diagnostics.append("Unary operator '\(String(describing: syntax.operatorToken.text))' is not defined for type \(boundOperand.expressionType)")
            return boundOperand
        }
        return BoundUnaryExpression(op: boundOperator, operand: boundOperand)
    }
    
    private func bindLiteralExpression(_ syntax: LiteralExpressionSyntax) -> BoundExpression {
        let value = syntax.value ?? 0
        return BoundLiteralExpression(value: value)
    }
    
    /*private func bindUnaryOperatorKind(_ kind: SyntaxKind, _ operandType: Any) throws -> BoundUnaryOperatorKind? {
        if operandType is Int {
            switch kind {
            case .pluseToken:
                return .identity
            case .minusToken:
                return .negation
            default: break
            }
            
        }
        
        if operandType is Bool {
            switch kind {
            case .bangToken:
                return .logicalNagarion
            default: break
            }
            
            
        }
        
        return nil
       
    }*/
    
    /*private func bindBinaryOperatorKind(_ kind: SyntaxKind, _ leftType: Any, _ rightType: Any) throws -> BoundBinaryOperatorKind? {
        if leftType is Int && leftType is Int {
            switch kind {
            case .pluseToken:
                return .addition
            case .minusToken:
                return .substruction
            case .starToken:
                return .multiplication
            case .slashToken:
                return .division
            default: break
            }
        }
        
        if leftType is Bool && leftType is Bool {
            switch kind {
            case .ampersantAmpersantToken:
                return .logicalAnd
            case .pipePipeToken:
                return .logicalOr
            default: break
            }
        }
        
        return nil
    }*/
}
