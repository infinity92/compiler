//
//  BoundVariableDeclaration.swift
//  Winter
//
//  Created by Александр Котляров on 18.11.2021.
//

import Foundation

struct BoundVariableDeclaration: BoundStatement {
    var kind: BoundNodeKind {
        .variableDeclatation
    }
    public let variable: VariableSymbol
    public let initializer: BoundExpression
}
