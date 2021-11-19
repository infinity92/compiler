//
//  SyntaxKind.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

public enum SyntaxKind: CaseIterable {
    // MARK: - Tokens
    case numberToken
    case pluseToken
    case whitespaceToken
    case minusToken
    case starToken
    case slashToken
    case openParenthesisToken
    case closeParenthesisToken
    case openBraceToken
    case closeBraceToken
    case badToken
    case endOfFileToken
    case identifierToken
    case bangToken
    case ampersantAmpersantToken
    case pipePipeToken
    case equalsEqualsToken
    case bangEqualsToken
    case equalsToken
    case lessOrEqualToken
    case lessToken
    case greaterToken
    case greaterOrEqualToken
    
    // MARK: - Nodes
    case compilationUnit
    
    // MARK: - Statement
    case blockStatement
    case expressionStatement
    case variableDeclatation
    case ifStatement
    case elseClause
    case whileStatement
    
    // MARK: - Expressions
    case literalExpression
    case unaryExpression
    case binaryExpression
    case parenthesizedExpression
    case nameExpression
    case assigmentExpression
    
    // MARK: - Keyword
    case trueKeyword
    case falseKeyword
    case letKeyword
    case varKeyword
    case ifKeyword
    case elseKeyword
    case whileKeyword
    
    
    func getBinaryOperatorPrecedence() -> Int {
        switch self {
        case .starToken, .slashToken:
            return 5
        case .pluseToken, .minusToken:
            return 4
        case .equalsEqualsToken, .bangEqualsToken, .lessToken, .lessOrEqualToken, .greaterToken, .greaterOrEqualToken:
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




