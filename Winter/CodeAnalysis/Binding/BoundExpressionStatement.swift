//
//  BoundExpressionStatement.swift.swift
//  Winter
//
//  Created by Александр Котляров on 17.11.2021.
//

import Foundation

struct BoundExpressionStatement: BoundStatement {
    public var kind: BoundNodeKind {
        .expressionStatement
    }
    
    public let expression: BoundExpression
}
