//
//  BlockStatementSyntax.swift
//  Winter
//
//  Created by Александр Котляров on 17.11.2021.
//

import Foundation

public struct BlockStatementSyntax: StatementSyntax {
    public var kind: SyntaxKind {
        .blockStatement
    }
    
    public let openBraceToken: SyntaxToken
    public let statements: [StatementSyntax]
    public let closeBraceToken: SyntaxToken
}
