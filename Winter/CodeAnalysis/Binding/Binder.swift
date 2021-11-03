//
//  Binder.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

class Binder {
    private(set) var diagnostics = DiagnosticBag()
    //private var variables: [VariableSymbol: Any]
    
//    init(_ variables: inout [VariableSymbol:Any]) {
//        self.variables = variables
//        variables["b"] = 3
//    }
    
    func bindExpression(syntax: ExpressionSyntax) throws -> BoundExpression {
        switch syntax.kind {
        case .unaryExpression:
            return bindUnaryExpression(syntax as! UnaryExpressionSyntax)
        case .binaryExpression:
            return bindBinaryExpression(syntax as! BinaryExpressionSyntax)
        case .literalExpression:
            return bindLiteralExpression(syntax as! LiteralExpressionSyntax)
        case .parenthesizedExpression:
            return bindParenthesizedExpression(syntax: (syntax as! ParenthesizedExpressionSyntax))
        case .nameExpression:
            return bindNameExpression(syntax: (syntax as! NameExpressionSyntax))
        case .assigmentExpression:
            return try! bindAssignmentExpression(syntax: (syntax as! AssigmentExpressionSyntax))
        default:
            throw Exception("Unxpected syntax \(syntax.kind)")
        }
    }
    
    private func bindNameExpression(syntax: NameExpressionSyntax) -> BoundExpression {
        let name = syntax.identifierToken.text!
        let variable = variables.keys.first { $0.name == name }
        
        if variable == nil {
            diagnostics.reportUndefinedName(syntax.identifierToken.span, name)
            return BoundLiteralExpression(value: 0)
        }
        
        return BoundVariableExpression(variable: variable!)
    }
    
    private func bindAssignmentExpression(syntax: AssigmentExpressionSyntax) throws -> BoundExpression {
        let name = syntax.identifierToken.text!
        let boundExpression = try! bindExpression(syntax: syntax.expression)
        
        let existingVariable = variables.keys.first { $0.name == name }
        if existingVariable != nil {
            variables.removeValue(forKey: existingVariable!)
        }
        let variable = VariableSymbol(name: name, varType: boundExpression.expressionType)
        variables[variable] = nil
        
        return BoundAssignmentExpression(variable: variable, expression: boundExpression)
    }
    
    private func bindParenthesizedExpression(syntax: ParenthesizedExpressionSyntax) -> BoundExpression {
        return try! bindExpression(syntax: syntax.expression)
    }
    
    private func bindBinaryExpression(_ syntax: BinaryExpressionSyntax) -> BoundExpression {
        let boundLeft = try! bindExpression(syntax: syntax.left)
        let boundRight = try! bindExpression(syntax: syntax.right)
        guard let boundOperator = BoundBinaryOperator.bind(syntaxKind: syntax.operatorToken.kind, leftType: boundLeft.expressionType, rightType: boundRight.expressionType) else {
            diagnostics.reportUndefinedBinaryOperator(
                syntax.operatorToken.span,
                syntax.operatorToken.text ?? "",
                boundLeft.expressionType,
                boundRight.expressionType)
            
            return boundLeft
        }
        return BoundBinaryExpression(left: boundLeft, op: boundOperator, right: boundRight)
    }
    
    private func bindUnaryExpression(_ syntax: UnaryExpressionSyntax) -> BoundExpression {
        let boundOperand = try! bindExpression(syntax: syntax.operand)
        guard let boundOperator = BoundUnaryOperator.bind(syntaxKind: syntax.operatorToken.kind, operandType: boundOperand.expressionType) else {
            diagnostics.reportUndefinedUnaryOperator(
                syntax.operatorToken.span,
                syntax.operatorToken.text ?? "",
                boundOperand.expressionType)
            
            return boundOperand
        }
        return BoundUnaryExpression(op: boundOperator, operand: boundOperand)
    }
    
    private func bindLiteralExpression(_ syntax: LiteralExpressionSyntax) -> BoundExpression {
        let value = syntax.value ?? 0
        return BoundLiteralExpression(value: value)
    }
}
