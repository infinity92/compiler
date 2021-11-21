//
//  BoundForStatement.swift
//  Winter
//
//  Created by Александр Котляров on 19.11.2021.
//

import Foundation

struct BoundForStatement: BoundStatement {
    var kind: BoundNodeKind {
        .forStatement
    }
    public let variable: VariableSymbol
    public let lowerBound: BoundExpression
    public let upperBound: BoundExpression
    public let body: BoundStatement
}
