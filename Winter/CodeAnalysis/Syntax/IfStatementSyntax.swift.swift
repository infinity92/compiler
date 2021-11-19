//
//  IfStatementSyntax.swift.swift
//  Winter
//
//  Created by Александр Котляров on 19.11.2021.
//

import Foundation

public struct IfStatementSyntax: StatementSyntax {
    public var kind: SyntaxKind {
        .ifStatement
    }
    public let ifKeyword: SyntaxToken
    public let condition: ExpressionSyntax
    public let thenStatement: StatementSyntax
    public let elseClause: ElseClauseSyntax?
}
