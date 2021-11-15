//
//  ParenthesizedExpressionSyntax.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

struct ParenthesizedExpressionSyntax: ExpressionSyntax {
    let openParenthesisToken: SyntaxToken
    let expression: ExpressionSyntax
    let closeParenthesisToken: SyntaxToken
    var kind: SyntaxKind {
        .parenthesizedExpression
    }
}
