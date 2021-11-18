//
//  UnaryExpressionSyntax.swift
//  compiler
//
//  Created by Александр Котляров on 26.10.2021.
//

import Foundation

struct UnaryExpressionSyntax: ExpressionSyntax {
    let operatorToken: SyntaxToken
    let operand: ExpressionSyntax
    var kind: SyntaxKind {
        .unaryExpression
    }
}
