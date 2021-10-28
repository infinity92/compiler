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
        guard let boundOperatorKind = try! bindBinaryOperatorKind(syntax.operatorToken.kind, boundLeft.type, boundRight.type) else {
            diagnostics.append("Binary operator '\(String(describing: syntax.operatorToken.text))' is not defined for type \(boundLeft.type) and \(boundRight.type)")
            return boundLeft
        }
        return BoundBinaryExpression(left: boundLeft, operatorKind: boundOperatorKind, right: boundRight)
    }
    
    private func bindUnaryExpression(_ syntax: UnaryExpressionSyntax) -> BoundExpression {
        let boundOperand = try! bindExpression(syntax: syntax.operand)
        guard let boundOperatorKind = try! bindUnaryOperatorKind(syntax.operatorToken.kind, boundOperand.type) else {
            diagnostics.append("Unary operator '\(String(describing: syntax.operatorToken.text))' is not defined for type \(boundOperand.type)")
            return boundOperand
        }
        return BoundUnaryExpression(operatorKind: boundOperatorKind, operand: boundOperand)
    }
    
    private func bindLiteralExpression(_ syntax: LiteralExpressionSyntax) -> BoundExpression {
        let value = syntax.value ?? 0
        return BoundLiteralExpression(value: value)
    }
    
    private func bindUnaryOperatorKind(_ kind: SyntaxKind, _ operandType: Any) throws -> BoundUnaryOperatorKind? {
        if !(operandType is Int) {
            return nil
        }
        
        switch kind {
        case .pluseToken:
            return .identity
        case .minusToken:
            return .negation
        default:
            throw Exception("Unexpected unary operator \(kind)")
        }
    }
    
    private func bindBinaryOperatorKind(_ kind: SyntaxKind, _ leftType: Any, _ rightType: Any) throws -> BoundBinaryOperatorKind? {
        if !(leftType is Int) || !(leftType is Int) {
            return nil
        }
        switch kind {
        case .pluseToken:
            return .addition
        case .minusToken:
            return .substruction
        case .starToken:
            return .multiplication
        case .slashToken:
            return .division
        default:
            throw Exception("Unexpected binary operator \(kind)")
        }
    }
}
