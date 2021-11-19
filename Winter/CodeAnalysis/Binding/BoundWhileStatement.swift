//
//  BoundWhileStatement.swift
//  Winter
//
//  Created by Александр Котляров on 19.11.2021.
//

import Foundation

struct BoundWhileStatement: BoundStatement {
    var kind: BoundNodeKind {
        .whileStatement
    }
    public let condition: BoundExpression
    public let body: BoundStatement
}
