//
//  ExpressionStatementSyntax.swift
//  Winter
//
//  Created by Александр Котляров on 17.11.2021.
//

import Foundation

public struct ExpressionStatementSyntax: StatementSyntax {
    public var kind: SyntaxKind {
        .expressionStatement
    }
    public let expression: ExpressionSyntax
}
