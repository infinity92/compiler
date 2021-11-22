//
//  BoundBinaryOperator.swift
//  compiler
//
//  Created by Александр Котляров on 29.10.2021.
//

import Foundation

struct BoundBinaryOperator {
    init(syntaxKind: SyntaxKind, kind: BoundBinaryOperatorKind, leftType: Any.Type, rightType: Any.Type, resultType: Any.Type) {
        self.syntaxKind = syntaxKind
        self.kind = kind
        self.leftType = leftType
        self.rightType = rightType
        self.operatorType = resultType
    }
    
    init(syntaxKind: SyntaxKind, kind: BoundBinaryOperatorKind, operandType: Any.Type, resultType: Any.Type) {
        self.init(syntaxKind: syntaxKind, kind: kind, leftType: operandType, rightType: operandType, resultType: resultType)
    }
    
    init(syntaxKind: SyntaxKind, kind: BoundBinaryOperatorKind, type: Any.Type) {
        self.init(syntaxKind: syntaxKind, kind: kind, leftType: type, rightType: type, resultType: type)
    }
    
    let syntaxKind: SyntaxKind
    let kind: BoundBinaryOperatorKind
    let leftType: Any.Type
    let rightType: Any.Type
    let operatorType: Any.Type
    
    private static let operators: [BoundBinaryOperator] = [
        BoundBinaryOperator(syntaxKind: .pluseToken, kind: .addition, type: Int.self),
        BoundBinaryOperator(syntaxKind: .minusToken, kind: .substruction, type: Int.self),
        BoundBinaryOperator(syntaxKind: .starToken, kind: .multiplication, type: Int.self),
        BoundBinaryOperator(syntaxKind: .slashToken, kind: .division, type: Int.self),
        BoundBinaryOperator(syntaxKind: .ampersantToken, kind: .bitwiseAnd, type: Int.self),
        BoundBinaryOperator(syntaxKind: .pipeToken, kind: .bitwiseOr, type: Int.self),
        BoundBinaryOperator(syntaxKind: .hatToken, kind: .bitwiseXor, type: Int.self),
        BoundBinaryOperator(syntaxKind: .equalsEqualsToken, kind: .equals, operandType: Int.self, resultType: Bool.self),
        BoundBinaryOperator(syntaxKind: .bangEqualsToken, kind: .notEquals, operandType: Int.self, resultType: Bool.self),
        BoundBinaryOperator(syntaxKind: .lessToken, kind: .less, operandType: Int.self, resultType: Bool.self),
        BoundBinaryOperator(syntaxKind: .lessOrEqualToken, kind: .lessOrEquals, operandType: Int.self, resultType: Bool.self),
        BoundBinaryOperator(syntaxKind: .greaterToken, kind: .greater, operandType: Int.self, resultType: Bool.self),
        BoundBinaryOperator(syntaxKind: .greaterOrEqualToken, kind: .greaterOrEquals, operandType: Int.self, resultType: Bool.self),
        
        BoundBinaryOperator(syntaxKind: .ampersantToken, kind: .bitwiseAnd, type: Bool.self),
        BoundBinaryOperator(syntaxKind: .ampersantAmpersantToken, kind: .logicalAnd, type: Bool.self),
        BoundBinaryOperator(syntaxKind: .pipeToken, kind: .bitwiseOr, type: Bool.self),
        BoundBinaryOperator(syntaxKind: .pipePipeToken, kind: .logicalOr, type: Bool.self),
        BoundBinaryOperator(syntaxKind: .hatToken, kind: .bitwiseXor, type: Bool.self),
        BoundBinaryOperator(syntaxKind: .equalsEqualsToken, kind: .equals, type: Bool.self),
        BoundBinaryOperator(syntaxKind: .bangEqualsToken, kind: .notEquals, type: Bool.self),
    ]
    
    static func bind(syntaxKind: SyntaxKind, leftType: Any.Type, rightType: Any.Type) -> BoundBinaryOperator? {
        for op in operators {
            if op.syntaxKind == syntaxKind && op.leftType == leftType && op.rightType == rightType {
                return op
            }
        }
        return nil
    }
}


