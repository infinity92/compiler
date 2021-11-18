//
//  VariableDeclarationSyntax.swift
//  Winter
//
//  Created by Александр Котляров on 18.11.2021.
//

import Foundation

public struct VariableDeclatationSyntax: StatementSyntax {
    public var kind: SyntaxKind {
        .variableDeclatation
    }
    public let keyword: SyntaxToken
    public let identifier: SyntaxToken
    public let equalsToken: SyntaxToken
    public let initializer: ExpressionSyntax
}
