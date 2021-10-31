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
    private(set) var diagnostics: [String] = []
    
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
        diagnostics.append(contentsOf: lexer.diagnostics)
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
        diagnostics.append("ERROR: Unexpected token <\(current.kind)>, expected <\(kind)>")
        return SyntaxToken(kind: kind, position: current.position, text: nil, value: nil)
    }
    
    private func parseExpression(parentPrecedence: Int = 0) -> ExpressionSyntax {
        var left: ExpressionSyntax
        //Get the priority of the unary operator
        //If it is not operator then return 0
        let unaryOperatorPrecedence = current.kind.getUnaryOperatorPrecedence()
        if unaryOperatorPrecedence != 0 && unaryOperatorPrecedence >= parentPrecedence {
            let operatorToken = nextToken()
            let operand = parseExpression(parentPrecedence: unaryOperatorPrecedence)
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
            let right = parseExpression(parentPrecedence: precedence)
            left = BinaryExpressionSyntax(left: left, operatorToken: operatorToken, right: right)
        }
        
        return left
    }
    
    func parse() -> SyntaxTree {
        let expression = parseExpression()
        let endOfFileToken = matchToken(kind: .endOfFileToken)
        
        return SyntaxTree(root: expression, endOfFileToken: endOfFileToken, diagnostics: diagnostics)
    }
    
    private func parsePrimaryExpression() -> ExpressionSyntax {
        switch current.kind {
        case .openParenthesisToken:
            let left = nextToken()
            let expression = parseExpression()
            let right = matchToken(kind: .closeParenthesisToken)
            
            return ParenthesizedExpressionSyntax(openParenthesisToken: left, expression: expression, closeParenthesisToken: right)
        case .falseKeyword, .trueKeyword:
            let keywordToken = nextToken()
            let value = (keywordToken.kind == .trueKeyword)
            
            return LiteralExpressionSyntax(literalToken: keywordToken, value: value)
        default:
            let numberToken = matchToken(kind: .numberToken)
            return LiteralExpressionSyntax(literalToken: numberToken)
        }
    }
}



