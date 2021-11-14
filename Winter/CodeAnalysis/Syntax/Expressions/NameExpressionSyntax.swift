//
//  NameExpressionSyntax.swift
//  compiler
//
//  Created by Александр Котляров on 01.11.2021.
//

import Foundation

struct NameExpressionSyntax: ExpressionSyntax {
    let identifierToken: SyntaxToken
    var kind: SyntaxKind {
        .nameExpression
    }
}
