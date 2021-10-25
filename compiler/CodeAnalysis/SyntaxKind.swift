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
    case numberExpression
    case binaryExpression
    case parenthesizedExpression
}
