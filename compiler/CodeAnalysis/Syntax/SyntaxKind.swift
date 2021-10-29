//
//  SyntaxKind.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

enum SyntaxKind {
    // MARK: - Tokens
    case numberToken
    case pluseToken
    case whitespaceToken
    case minusToken
    case starToken
    case slashToken
    case openParenthesisToken
    case closeParenthesisToken
    case badToken
    case endOfFileToken
    case identifierToken
    case bangToken
    case ampersantAmpersantToken
    case pipePipeToken
    case equalsEqualsToken
    case bangEqualsToken
    
    // MARK: - Expressions
    case literalExpression
    case unaryExpression
    case binaryExpression
    case parenthesizedExpression
    
    // MARK: - Keyword
    case trueKeyword
    case falseKeyword
    
    
    func getBinaryOperatorPrecedence() -> Int {
        switch self {
        case .starToken, .slashToken:
            return 5
        case .pluseToken, .minusToken:
            return 4
        case .equalsEqualsToken, .bangEqualsToken:
            return 3
        case .ampersantAmpersantToken:
            return 2
        case .pipePipeToken:
            return 1
        default:
            return 0
        }
    }
    
    func getUnaryOperatorPrecedence() -> Int {
        switch self {
        case .pluseToken, .minusToken, .bangToken:
            return 6
        default:
            return 0
        }
    }
}




