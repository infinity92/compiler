//
//  CompilationUnitSyntax.swift
//  Winter
//
//  Created by Александр Котляров on 15.11.2021.
//

import Foundation

public struct CompilationUnitSyntax: SyntaxNode {
    public var kind: SyntaxKind {
        .compilationUnit
    }
    public let expression: ExpressionSyntax
    public let endOfFileToken: SyntaxToken
}
