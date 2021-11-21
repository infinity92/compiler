//
//  BoundAssignmentExpression.swift
//  compiler
//
//  Created by Александр Котляров on 01.11.2021.
//

import Foundation

struct BoundAssignmentExpression: BoundExpression {
    var expressionType: Any.Type {
        expression.expressionType
    }
    var kind: BoundNodeKind {
        .assignmentExpression
    }
    let variable: VariableSymbol
    let expression: BoundExpression
    
}
