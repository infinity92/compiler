//
//  ElseClauseSyntax.swift
//  Winter
//
//  Created by Александр Котляров on 19.11.2021.
//

import Foundation

public struct ElseClauseSyntax: SyntaxNode {
    public var kind: SyntaxKind {
        .elseClause
    }
    public let elseKeyword: SyntaxToken
    public let elseStatement: StatementSyntax
}
