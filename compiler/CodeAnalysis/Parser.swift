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
            token = lexer.nextToken()
            
            if token.kind != .whitespaceToken && token.kind != .badToken {
                tokens.append(token)
            }
        } while token.kind != SyntaxKind.endOfFileToken
        
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
    
    private func parseTerm() -> ExpressionSyntax {
        var left = parseFactor()
        
        while current.kind == .pluseToken ||
                current.kind == .minusToken
        {
            let operatorToken = nextToken()
            let right = parseFactor()
            left = BinaryExpressionSyntax(left: left, operatorToken: operatorToken, right: right)
        }
        
        return left
    }
    
    private func parseFactor() -> ExpressionSyntax {
        var left = parsePrimaryExpression()
        
        while current.kind == .starToken ||
                current.kind == .slashToken
        {
            let operatorToken = nextToken()
            let right = parsePrimaryExpression()
            left = BinaryExpressionSyntax(left: left, operatorToken: operatorToken, right: right)
        }
        
        return left
    }
    
    private func pareExpression() -> ExpressionSyntax {
        return parseTerm()
    }
    
    func parse() -> SyntaxTree {
        let expression = parseTerm()
        let endOfFileToken = matchToken(kind: .endOfFileToken)
        
        return SyntaxTree(root: expression, endOfFileToken: endOfFileToken, diagnostics: diagnostics)
    }
    
    private func parsePrimaryExpression() -> ExpressionSyntax {
        if current.kind == .openParenthesisToken {
            let left = nextToken()
            let expression = pareExpression()
            let right = matchToken(kind: .closeParenthesisToken)
            
            return ParenthesizedExpressionSyntax(openParenthesisToken: left, expression: expression, closeParenthesisToken: right)
        }
        let numberToken = matchToken(kind: .numberToken)
        return LiteralExpressionSyntax(literalToken: numberToken)
    }
}
