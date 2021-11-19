//
//  BoundIfStatement.swift
//  Winter
//
//  Created by Александр Котляров on 19.11.2021.
//

import Foundation

struct BoundIfStatement: BoundStatement {
    public var kind: BoundNodeKind {
        .ifStatement
    }
    public let condition: BoundExpression
    public let thenStatement: BoundStatement
    public let elseStatement: BoundStatement?
}
