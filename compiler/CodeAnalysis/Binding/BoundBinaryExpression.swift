//
//  BoundBinaryExpression.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

struct BoundBinaryExpression: BoundExpression {
    let left: BoundExpression
    let operatorKind: BoundBinaryOperatorKind
    let right: BoundExpression
    
    var kind: BoundNodeKind {
        .unaryExpression
    }
    
    var type: Any  {
        left.self
    }
}
