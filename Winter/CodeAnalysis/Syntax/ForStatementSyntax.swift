//
//  ForStatementSyntax.swift
//  Winter
//
//  Created by Александр Котляров on 19.11.2021.
//

import Foundation

public struct ForStatementSyntax: StatementSyntax {
    public var kind: SyntaxKind {
        .forStatement
    }
    public let keyword: SyntaxToken
    public let identifier: SyntaxToken
    public let equalsToken: SyntaxToken
    public let lowerBound: ExpressionSyntax
    public let toKeyword: SyntaxToken
    public let upperBound: ExpressionSyntax
    public let body: StatementSyntax
}
