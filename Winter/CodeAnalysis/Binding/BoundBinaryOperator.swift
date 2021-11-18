//
//  BoundBinaryOperator.swift
//  compiler
//
//  Created by Александр Котляров on 29.10.2021.
//

import Foundation

struct BoundBinaryOperator {
    init(syntaxKind: SyntaxKind, kind: BoundBinaryOperatorKind, leftType: Any, rightType: Any, resultType: Any) {
        self.syntaxKind = syntaxKind
        self.kind = kind
        self.leftType = leftType
        self.rightType = rightType
        self.operatorType = resultType
    }
    
    init(syntaxKind: SyntaxKind, kind: BoundBinaryOperatorKind, operandType: Any, resultType: Any) {
        self.init(syntaxKind: syntaxKind, kind: kind, leftType: operandType, rightType: operandType, resultType: resultType)
    }
    
    init(syntaxKind: SyntaxKind, kind: BoundBinaryOperatorKind, type: Any) {
        self.init(syntaxKind: syntaxKind, kind: kind, leftType: type, rightType: type, resultType: type)
    }
    
    let syntaxKind: SyntaxKind
    let kind: BoundBinaryOperatorKind
    let leftType: Any
    let rightType: Any
    let operatorType: Any
    
    private static let operators: [BoundBinaryOperator] = [
        BoundBinaryOperator(syntaxKind: .pluseToken, kind: .addition, type: Int.self),
        BoundBinaryOperator(syntaxKind: .minusToken, kind: .substruction, type: Int.self),
        BoundBinaryOperator(syntaxKind: .starToken, kind: .multiplication, type: Int.self),
        BoundBinaryOperator(syntaxKind: .slashToken, kind: .division, type: Int.self),
        BoundBinaryOperator(syntaxKind: .equalsEqualsToken, kind: .equals, operandType: Int.self, resultType: Bool.self),
        BoundBinaryOperator(syntaxKind: .bangEqualsToken, kind: .notEquals, operandType: Int.self, resultType: Bool.self),
        BoundBinaryOperator(syntaxKind: .lessToken, kind: .less, operandType: Int.self, resultType: Bool.self),
        BoundBinaryOperator(syntaxKind: .lessOrEqualToken, kind: .lessOrEquals, operandType: Int.self, resultType: Bool.self),
        BoundBinaryOperator(syntaxKind: .greaterToken, kind: .greater, operandType: Int.self, resultType: Bool.self),
        BoundBinaryOperator(syntaxKind: .greaterOrEqualToken, kind: .greaterOrEquals, operandType: Int.self, resultType: Bool.self),
        
        BoundBinaryOperator(syntaxKind: .ampersantAmpersantToken, kind: .logicalAnd, type: Bool.self),
        BoundBinaryOperator(syntaxKind: .pipePipeToken, kind: .logicalOr, type: Bool.self),
        BoundBinaryOperator(syntaxKind: .equalsEqualsToken, kind: .equals, type: Bool.self),
        BoundBinaryOperator(syntaxKind: .bangEqualsToken, kind: .notEquals, type: Bool.self),
    ]
    
    static func bind(syntaxKind: SyntaxKind, leftType: Any, rightType: Any) -> BoundBinaryOperator? {
        for op in operators {
            if op.syntaxKind == syntaxKind && type(of: op.leftType) == type(of: leftType) && type(of: op.rightType) == type(of: rightType) {
                return op
            }
        }
        return nil
    }
}


