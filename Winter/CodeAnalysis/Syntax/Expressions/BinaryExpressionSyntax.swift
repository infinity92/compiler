//
//  BinaryExpressionSyntax.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

struct BinaryExpressionSyntax: ExpressionSyntax {
    let left: ExpressionSyntax
    let operatorToken: SyntaxToken
    let right: ExpressionSyntax
    var kind: SyntaxKind {
        .binaryExpression
    }
    
    func getChildren() -> Array<SyntaxNode> {
        return [
            left,
            operatorToken,
            right
        ]
    }
}
