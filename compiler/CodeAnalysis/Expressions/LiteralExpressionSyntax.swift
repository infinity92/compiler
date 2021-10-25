//
//  NumberExpressionSyntax.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

struct LiteralExpressionSyntax: ExpressionSyntax {
    let literalToken: SyntaxToken
    var kind: SyntaxKind {
        .literalExpression
    }
    
    func getChildren() -> Array<SyntaxNode> {
        return [literalToken]
    }
}