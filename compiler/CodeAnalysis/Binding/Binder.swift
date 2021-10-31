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
        case .parenthesizedExpression:
            return try! bindExpression(syntax: (syntax as! ParenthesizedExpressionSyntax).expression)
        default:
            throw Exception("Unxpected syntax \(syntax.kind)")
        }
    }
    
    private func bindBinaryExpression(_ syntax: BinaryExpressionSyntax) -> BoundExpression {
        let boundLeft = try! bindExpression(syntax: syntax.left)
        let boundRight = try! bindExpression(syntax: syntax.right)
        guard let boundOperator = BoundBinaryOperator.bind(syntaxKind: syntax.operatorToken.kind, leftType: boundLeft.expressionType, rightType: boundRight.expressionType) else {
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
}
