//
//  File.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

struct BoundLiteralExpression: BoundExpression {
    let value: Any
    var kind: BoundNodeKind {
        .literalExpression
    }
    var expressionType: Any.Type {
        type(of: value)
    }
}
