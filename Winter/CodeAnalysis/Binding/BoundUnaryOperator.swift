//
//  BoundUnaryOperator.swift
//  compiler
//
//  Created by Александр Котляров on 29.10.2021.
//

import Foundation

struct BoundUnaryOperator {
    init(syntaxKind: SyntaxKind, kind: BoundUnaryOperatorKind, operandType: Any.Type, resultType: Any.Type) {
        self.syntaxKind = syntaxKind
        self.kind = kind
        self.operandType = operandType
        self.operatorType = resultType
    }
    
    init(syntaxKind: SyntaxKind, kind: BoundUnaryOperatorKind, operandType: Any.Type) {
        self.init(syntaxKind: syntaxKind, kind: kind, operandType: operandType, resultType: operandType)
    }
    
    let syntaxKind: SyntaxKind
    let kind: BoundUnaryOperatorKind
    let operandType: Any.Type
    let operatorType: Any.Type
    
    private static let operators: [BoundUnaryOperator] = [
        BoundUnaryOperator(syntaxKind: .bangToken, kind: .logicalNagarion, operandType: Bool.self),
        
        BoundUnaryOperator(syntaxKind: .pluseToken, kind: .identity, operandType: Int.self),
        BoundUnaryOperator(syntaxKind: .minusToken, kind: .negation, operandType: Int.self),
        BoundUnaryOperator(syntaxKind: .tildeToken, kind: .onesComplement, operandType: Int.self)
    ]
    
    static func bind(syntaxKind: SyntaxKind, operandType: Any.Type) -> BoundUnaryOperator? {
        for op in operators {
            if op.syntaxKind == syntaxKind && op.operandType == operandType {
                return op
            }
        }
        
        return nil
    }
}

//extension BoundUnaryOperator: Equatable {
//    static func == (lhs: BoundUnaryOperator, rhs: BoundUnaryOperator) -> Bool {
//        lhs.syntaxKind == rhs.syntaxKind
//        && lhs.kind == rhs.kind
//        && lhs.operandType == rhs.operandType
//        && lhs.operatorType == rhs.operandType
//    }
//}
