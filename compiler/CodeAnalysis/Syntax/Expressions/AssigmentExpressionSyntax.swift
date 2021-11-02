//
//  AssigmentExpressionSyntax.swift
//  compiler
//
//  Created by Александр Котляров on 01.11.2021.
//

import Foundation

struct AssigmentExpressionSyntax: ExpressionSyntax {
    let identifierToken: SyntaxToken
    let equalsToken: SyntaxToken
    let expression: ExpressionSyntax
    var kind: SyntaxKind {
        .assigmentExpression
    }
    func getChildren() -> Array<SyntaxNode> {
        return [identifierToken, equalsToken, expression]
    }
}
