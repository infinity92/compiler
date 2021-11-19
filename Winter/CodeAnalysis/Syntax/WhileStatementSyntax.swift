//
//  WhileStatementSyntax.swift
//  Winter
//
//  Created by Александр Котляров on 19.11.2021.
//

import Foundation

public struct WhileStatementSyntax: StatementSyntax {
    public var kind: SyntaxKind {
        .whileStatement
    }
    public let whileKeyword: SyntaxToken
    public let condition: ExpressionSyntax
    public let body: StatementSyntax
}
