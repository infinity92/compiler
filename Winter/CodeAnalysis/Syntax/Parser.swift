//
//  Parser.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

class Parser {
    private let tokens: [SyntaxToken]
    private var position: Int = 0
    private var current: SyntaxToken {
        // TODO: create factory methods in future
        peek(0)
    }
    private(set) var diagnostics = DiagnosticBag()
    
    init(text: String) {
        var tokens: [SyntaxToken] = []
        let lexer = Lexer(text: text)
        var token: SyntaxToken
        repeat {
            token = lexer.lex()
            
            if token.kind != .whitespaceToken && token.kind != .badToken {
                tokens.append(token)
            }
        } while token.kind != .endOfFileToken
        
        self.tokens = tokens
        diagnostics.addRange(lexer.diagnostics)
    }
    
    private func peek(_ offset: Int) -> SyntaxToken {
        let index = position + offset
        if index >= tokens.count {
            return tokens[tokens.count - 1]
        }
        
        return tokens[index]
    }
    
    private func nextToken() -> SyntaxToken {
        let current = self.current
        position += 1
        return current
    }
    
    private func matchToken(kind: SyntaxKind) -> SyntaxToken {
        if current.kind == kind {
            return nextToken()
        }
        diagnostics.reportUnexpectedToken(current.span, current.kind, kind)
        return SyntaxToken(kind: kind, position: current.position, text: nil, value: nil)
    }
    
    private func parseBinaryExpression(parentPrecedence: Int = 0) -> ExpressionSyntax {
        var left: ExpressionSyntax
        //Get the priority of the unary operator
        //If it is not operator then return 0
        let unaryOperatorPrecedence = current.kind.getUnaryOperatorPrecedence()
        if unaryOperatorPrecedence != 0 && unaryOperatorPrecedence >= parentPrecedence {
            let operatorToken = nextToken()
            let operand = parseBinaryExpression(parentPrecedence: unaryOperatorPrecedence)
            left = UnaryExpressionSyntax(operatorToken: operatorToken, operand: operand)
        } else {
            left = parsePrimaryExpression()
        }
        
        while true {
            let precedence = current.kind.getBinaryOperatorPrecedence()
            if precedence == 0 || precedence <= parentPrecedence {
                break
            }
            
            let operatorToken = nextToken()
            let right = parseBinaryExpression(parentPrecedence: precedence)
            left = BinaryExpressionSyntax(left: left, operatorToken: operatorToken, right: right)
        }
        
        return left
    }
    
    func parse() -> SyntaxTree {
        let expression = parseExpression()
        let endOfFileToken = matchToken(kind: .endOfFileToken)
        
        return SyntaxTree(root: expression, endOfFileToken: endOfFileToken, diagnostics: diagnostics)
    }
    
    private func parseExpression() -> ExpressionSyntax {
        return parseAssigmentExpression()
    }
    
    private func parseAssigmentExpression() -> ExpressionSyntax {
        if peek(0).kind == .identifierToken && peek(1).kind == .equalsToken {
            let identifierToken = nextToken()
            let operatorToken = nextToken()
            let right = parseAssigmentExpression()
            return AssigmentExpressionSyntax(identifierToken: identifierToken, equalsToken: operatorToken, expression: right)
        }
        
        return parseBinaryExpression()
    }
    
    private func parseNameExpression() -> ExpressionSyntax {
        let identifierToken = matchToken(kind: .identifierToken)
        return NameExpressionSyntax(identifierToken: identifierToken)
    }
    
    private func parseBooleanExpression() -> ExpressionSyntax {
        let isTrue = current.kind == .trueKeyword
        let keywordToken = isTrue ? matchToken(kind: .trueKeyword) : matchToken(kind: .falseKeyword)
        
        return LiteralExpressionSyntax(literalToken: keywordToken, value: isTrue)
    }
    
    private func parseParenthesizedExpression() -> ExpressionSyntax {
        let left = matchToken(kind: .openParenthesisToken)
        let expression = parseExpression()
        let right = matchToken(kind: .closeParenthesisToken)
        
        return ParenthesizedExpressionSyntax(openParenthesisToken: left, expression: expression, closeParenthesisToken: right)
    }
    
    fileprivate func parseNumberLiteral() -> ExpressionSyntax {
        let numberToken = matchToken(kind: .numberToken)
        return LiteralExpressionSyntax(literalToken: numberToken)
    }
    
    private func parsePrimaryExpression() -> ExpressionSyntax {
        switch current.kind {
        case .openParenthesisToken:
            return parseParenthesizedExpression()
        case .falseKeyword, .trueKeyword:
            return parseBooleanExpression()
        case .numberToken:
            return parseNumberLiteral()
        case .identifierToken:
            return parseNameExpression()
        default:
            return parseNameExpression()
        }
    }
}



