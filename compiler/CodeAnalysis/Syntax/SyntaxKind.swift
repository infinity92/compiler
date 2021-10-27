//
//  SyntaxKind.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

enum SyntaxKind {
    // MARK: Tokens
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
    
    // MARK: Expressions
    case literalExpression
    case unaryExpression
    case binaryExpression
    case parenthesizedExpression
    
    func getBinaryOperatorPrecedence() -> Int {
        switch self {
        case .starToken, .slashToken:
            return 2
        case .pluseToken, .minusToken:
            return 1
        default:
            return 0
        }
    }
    
    func getUnaryOperatorPrecedence() -> Int {
        switch self {
        case .pluseToken, .minusToken:
            return 1
        default:
            return 0
        }
    }
}

/*
class SyntaxFacts {
    public static func getBinaryOperatorPrecedence(kind: SyntaxKind) -> Int {
        switch kind {
        case .starToken, .slashToken:
            return 2
        case .pluseToken, .minusToken:
            return 1
        default:
            return 0
        }
    }
}
*/
