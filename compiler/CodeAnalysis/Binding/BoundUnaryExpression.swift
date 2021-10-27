//
//  BoundUnaryExpression.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

struct BoundUnaryExpression: BoundExpression {
    let operatorKind: BoundUnaryOperatorKind
    let operand: BoundExpression
    
    var kind: BoundNodeKind {
        .unaryExpression
    }
    
    var type: Any  {
        operand.self
    }
}
