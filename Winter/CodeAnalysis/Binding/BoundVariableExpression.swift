//
//  BoundVariableExpression.swift
//  compiler
//
//  Created by Александр Котляров on 01.11.2021.
//

import Foundation

struct BoundVariableExpression: BoundExpression {
    let variable: VariableSymbol
    var expressionType: Any.Type {
        variable.varType
    }
    var kind: BoundNodeKind {
        .variableExpression
    }
}
