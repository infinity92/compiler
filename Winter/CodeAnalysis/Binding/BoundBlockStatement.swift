//
//  BoundBlockStatement.swift
//  Winter
//
//  Created by Александр Котляров on 17.11.2021.
//

import Foundation

struct BoundBlockStatement: BoundStatement {
    public var kind: BoundNodeKind {
        .blockStatement
    }
    public let statements: [BoundStatement]
}
