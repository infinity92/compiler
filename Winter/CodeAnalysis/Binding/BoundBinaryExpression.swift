//
//  BoundBinaryExpression.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

struct BoundBinaryExpression: BoundExpression {
    let left: BoundExpression
    let op: BoundBinaryOperator
    let right: BoundExpression
    
    var kind: BoundNodeKind {
        .binaryExpression
    }
    
    var expressionType: Any.Type  {
        op.operatorType
    }
}
