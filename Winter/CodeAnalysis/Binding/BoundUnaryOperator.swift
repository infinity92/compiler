//
//  BoundUnaryOperator.swift
//  compiler
//
//  Created by Александр Котляров on 29.10.2021.
//

import Foundation

struct BoundUnaryOperator {
    init(syntaxKind: SyntaxKind, kind: BoundUnaryOperatorKind, operandType: Any, resultType: Any) {
        self.syntaxKind = syntaxKind
        self.kind = kind
        self.operandType = operandType
        self.operatorType = resultType
    }
    
    init(syntaxKind: SyntaxKind, kind: BoundUnaryOperatorKind, operandType: Any) {
        self.init(syntaxKind: syntaxKind, kind: kind, operandType: operandType, resultType: operandType)
    }
    
    let syntaxKind: SyntaxKind
    let kind: BoundUnaryOperatorKind
    let operandType: Any
    let operatorType: Any
    
    private static let operators: [BoundUnaryOperator] = [
        BoundUnaryOperator(syntaxKind: .bangToken, kind: .logicalNagarion, operandType: Bool.self),
        
        BoundUnaryOperator(syntaxKind: .pluseToken, kind: .logicalNagarion, operandType: Int.self),
        BoundUnaryOperator(syntaxKind: .minusToken, kind: .logicalNagarion, operandType: Int.self),
    ]
    
    static func bind(syntaxKind: SyntaxKind, operandType: Any) -> BoundUnaryOperator? {
        for op in operators {
            if op.syntaxKind == syntaxKind && type(of: op.operandType) == type(of: operandType) {
                return op
            }
        }
        
        return nil
    }
}
