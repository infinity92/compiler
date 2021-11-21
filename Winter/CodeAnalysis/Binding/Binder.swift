//
//  Binder.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

class Binder {
    private(set) var diagnostics = DiagnosticBag()
    private var scope: BoundScope
    
    init(parent: BoundScope?) {
        scope = BoundScope(parent: parent)
    }
    
    public static func bindGlobalScope(previous: BoundGlobalScope?, syntax: CompilationUnitSyntax) -> BoundGlobalScope {
        let parentScope = createParentScopes(previous: previous)
        let binder = Binder(parent: parentScope)
        let expression = try! binder.bindStatement(syntax: syntax.statement)
        let variables = binder.scope.getDeclaredVariables()
        let diagnostics = binder.diagnostics
        
        return BoundGlobalScope(previous: previous, diagnostics: diagnostics, variables: variables, statement: expression)
    }
    
    private static func createParentScopes(previous: BoundGlobalScope?) -> BoundScope? {
        var previous = previous
        var stack = [BoundGlobalScope]()
        while previous != nil {
            stack.append(previous!)
            previous = previous!.previous
        }
        var parent: BoundScope? = nil
        while stack.count > 0 {
            let previous = stack.popLast()!
            let scope = BoundScope(parent: parent)
            for v in previous.variables {
                let _ = scope.tryDeclare(variable: v)
            }
            parent = scope
        }
        
        return parent
    }
    
    private func bindStatement(syntax: StatementSyntax) throws -> BoundStatement {
        switch syntax.kind {
        case .blockStatement:
            return bindBlockStatement(syntax as! BlockStatementSyntax)
        case .expressionStatement:
            return bindExpressionStatement(syntax as! ExpressionStatementSyntax)
        case .variableDeclatation:
            return bindVariableDeclaretion(syntax as! VariableDeclatationSyntax)
        case .ifStatement:
            return bindIfStatement(syntax as! IfStatementSyntax)
        case .whileStatement:
            return bindWhileStatement(syntax as! WhileStatementSyntax)
        case .forStatement:
            return bindForStatement(syntax as! ForStatementSyntax)
        default:
            throw Exception("Unxpected syntax \(syntax.kind)")
        }
    }
    
    private func bindForStatement(_ syntax: ForStatementSyntax) -> BoundStatement {
        let lowerBound = try! bindExpression(syntax: syntax.lowerBound, Int.self)
        let upperBound = try! bindExpression(syntax: syntax.upperBound, Int.self)
        
        scope = BoundScope(parent: scope)
        
        let name = syntax.identifier.text!
        let variable = VariableSymbol(name: name, isReadOnly: true, varType: Int.self)
        if !scope.tryDeclare(variable: variable) {
            diagnostics.reportVariableAlreadyDeclared(syntax.identifier.span, name)
        }
        
        let body = try! bindStatement(syntax: syntax.body)
        
        scope = scope.parent!
        
        return BoundForStatement(variable: variable, lowerBound: lowerBound, upperBound: upperBound, body: body)
    }
    
    private func bindWhileStatement(_ syntax: WhileStatementSyntax) -> BoundStatement {
        let condition = try! bindExpression(syntax: syntax.condition, Bool.self)
        let body = try! bindStatement(syntax: syntax.body)
        
        return BoundWhileStatement(condition: condition, body: body)
    }
    
    private func bindIfStatement(_ syntax: IfStatementSyntax) -> BoundStatement {
        let condition = try! bindExpression(syntax: syntax.condition, Bool.self)
        let thenStatemtnt = try! bindStatement(syntax: syntax.thenStatement)
        let elseStatement = syntax.elseClause == nil ? nil : try! bindStatement(syntax: syntax.elseClause!.elseStatement)
        
        return BoundIfStatement(condition: condition, thenStatement: thenStatemtnt, elseStatement: elseStatement)
        
    }
    
    private func bindVariableDeclaretion(_ syntax: VariableDeclatationSyntax) -> BoundStatement {
        let name = syntax.identifier.text!
        let isReadOnly = syntax.keyword.kind == .letKeyword
        let initializer = try! bindExpression(syntax: syntax.initializer)
        let variable = VariableSymbol(name: name, isReadOnly: isReadOnly, varType: initializer.expressionType)
        
        if !scope.tryDeclare(variable: variable) {
            diagnostics.reportVariableAlreadyDeclared(syntax.identifier.span, name)
        }
        
        return BoundVariableDeclaration(variable: variable, initializer: initializer)
    }
    
    private func bindExpressionStatement(_ syntax: ExpressionStatementSyntax) -> BoundStatement {
        let expression = try! bindExpression(syntax: syntax.expression)
        return BoundExpressionStatement(expression: expression)
    }
    
    private func bindBlockStatement(_ syntax: BlockStatementSyntax) -> BoundStatement {
        var statements = [BoundStatement]()
        scope = BoundScope(parent: scope)
        syntax.statements.forEach { statementSyntax in
            let statement = try! bindStatement(syntax: statementSyntax)
            statements.append(statement)
        }
        
        scope = scope.parent!
        
        return BoundBlockStatement(statements: statements)
    }
    
    private func bindExpression(syntax: ExpressionSyntax, _ targerType: Any.Type) throws -> BoundExpression {
        let result = try! bindExpression(syntax: syntax)
        if result.expressionType != targerType {
            diagnostics.reportCannotConvert(syntax.span, result.expressionType, targerType)
        }
        
        return result
    }
    
    private func bindExpression(syntax: ExpressionSyntax) throws -> BoundExpression {
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
        let name = syntax.identifierToken.text ?? ""
        var variable: VariableSymbol? = nil
        
        if !scope.tryLookup(name: name, variable: &variable) {
            diagnostics.reportUndefinedName(syntax.identifierToken.span, name)
            return BoundLiteralExpression(value: 0)
        }
        
        return BoundVariableExpression(variable: variable!)
    }
    
    private func bindAssignmentExpression(syntax: AssigmentExpressionSyntax) throws -> BoundExpression {
        let name = syntax.identifierToken.text!
        let boundExpression = try! bindExpression(syntax: syntax.expression)
        
        var variable: VariableSymbol? = nil
        if !scope.tryLookup(name: name, variable: &variable) {
            diagnostics.reportUndefinedName(syntax.identifierToken.span, name)
            return boundExpression
        }
        
        if variable!.isReadOnly {
            diagnostics.reportCannotAssign(syntax.equalsToken.span, name)
        }
        
        if boundExpression.expressionType != variable!.varType {
            diagnostics.reportCannotConvert(syntax.expression.span, boundExpression.expressionType, variable!.varType)
            return boundExpression
        }
        
        return BoundAssignmentExpression(variable: variable!, expression: boundExpression)
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
