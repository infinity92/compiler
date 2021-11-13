//
//  NumberExpressionSyntax.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

struct LiteralExpressionSyntax: ExpressionSyntax {
    
    init(literalToken: SyntaxToken, value: Any) {
        self.literalToken = literalToken
        self.value = value
    }
    
    init(literalToken: SyntaxToken) {
        self.literalToken = literalToken
        self.value = literalToken.value
    }
    
    let literalToken: SyntaxToken
    var kind: SyntaxKind {
        .literalExpression
    }
    let value: Any?
    
    func getChildren() -> Array<SyntaxNode> {
        return [literalToken]
    }
    
}
