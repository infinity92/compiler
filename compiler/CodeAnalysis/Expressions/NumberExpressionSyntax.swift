//
//  NumberExpressionSyntax.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

struct NumberExpressionSyntax: ExpressionSyntax {
    let numberToken: SyntaxToken
    var kind: SyntaxKind {
        .numberExpression
    }
    
    func getChildren() -> Array<SyntaxNode> {
        return [numberToken]
    }
}
