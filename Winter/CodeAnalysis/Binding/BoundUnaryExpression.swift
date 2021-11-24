//
//  BoundUnaryExpression.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

struct BoundUnaryExpression: BoundExpression {
    let op: BoundUnaryOperator
    let operand: BoundExpression
    
    var kind: BoundNodeKind {
        .unaryExpression
    }
    
    var expressionType: Any.Type  {
        op.operatorType
    }
}

//extension BoundUnaryExpression {
//    static func == (lhs: BoundUnaryExpression, rhs: BoundUnaryExpression) -> Bool {
//        lhs.kind == rhs.kind
//        && lhs.expressionType == rhs.expressionType
//        && lhs.operand == rhs.operand
//        && lhs.op == rhs.op
//    }
//}
