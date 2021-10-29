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
        self.resultType = resultType
    }
    
    init(syntaxKind: SyntaxKind, kind: BoundBinaryOperatorKind, operandType: Any, resultType: Any) {
        self.syntaxKind = syntaxKind
        self.kind = kind
        self.leftType = operandType
        self.rightType = operandType
        self.resultType = resultType
    }
    
    init(syntaxKind: SyntaxKind, kind: BoundBinaryOperatorKind, type: Any) {
        self.syntaxKind = syntaxKind
        self.kind = kind
        self.leftType = type
        self.rightType = type
        self.resultType = type
    }
    
    let syntaxKind: SyntaxKind
    let kind: BoundBinaryOperatorKind
    let leftType: Any
    let rightType: Any
    let resultType: Any
    
    private static let operators: [BoundBinaryOperator] = [
        BoundBinaryOperator(syntaxKind: .pluseToken, kind: .addition, type: Int.self),
        BoundBinaryOperator(syntaxKind: .minusToken, kind: .substruction, type: Int.self),
        BoundBinaryOperator(syntaxKind: .starToken, kind: .multiplication, type: Int.self),
        BoundBinaryOperator(syntaxKind: .slashToken, kind: .division, type: Int.self),
        
        BoundBinaryOperator(syntaxKind: .equalsEqualsToken, kind: .equals, operandType: Int.self, resultType: Bool.self),
        BoundBinaryOperator(syntaxKind: .bangEqualsToken, kind: .notEquals, operandType: Int.self, resultType: Bool.self),
        
        BoundBinaryOperator(syntaxKind: .ampersantAmpersantToken, kind: .logicalAnd, type: Bool.self),
        BoundBinaryOperator(syntaxKind: .pipePipeToken, kind: .logicalOr, type: Bool.self),
        
        BoundBinaryOperator(syntaxKind: .equalsEqualsToken, kind: .equals,  type: Bool.self),
        BoundBinaryOperator(syntaxKind: .bangEqualsToken, kind: .notEquals,  type: Bool.self),
    ]
    
    static func bind(syntaxKind: SyntaxKind, leftType: Any, rightType: Any) -> BoundBinaryOperator? {
        for op in operators {
//            print(syntaxKind, terminator: " == ")
//            print(op.syntaxKind)
//            print(type(of: op.leftType), terminator: " == ")
//            print(type(of: leftType))
//            print(type(of: op.rightType), terminator: " == ")
//            print(type(of: rightType))
//            print("==================")
            if op.syntaxKind == syntaxKind && type(of: op.leftType) == type(of: leftType) && type(of: op.rightType) == type(of: rightType) {
//                print("=======Success========")
                return op
            }
        }
//        print("=======failture========")
        return nil
    }
}


