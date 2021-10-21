//
//  Evaluator.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

class Evaluator {
    let root: ExpressionSyntax
    
    init(root: ExpressionSyntax) {
        self.root = root
    }
    
    func evaluate() -> Int {
        return try! evaluateExpression(root)
    }
    
    private func evaluateExpression(_ node: ExpressionSyntax) throws -> Int  {
        if let number = node as? NumberExpressionSyntax {
            return Int(number.numberToken.text ?? "")!
        }
        
        if let binary = node as? BinaryExpressionSyntax {
            let left = try! evaluateExpression(binary.left)
            let right = try! evaluateExpression(binary.right)
            
            if binary.operatorToken.kind == .pluseToken {
                return left + right
            } else if binary.operatorToken.kind == .minusToken {
                return left - right
            }
            else if binary.operatorToken.kind == .starToken {
                return left * right
            }
            else if binary.operatorToken.kind == .slashToken {
                return left / right
            } else {
                throw Exception("Unexpected binary operator \(binary.operatorToken.kind)")
            }
        }
        
        if let p = node as? ParenthesizedExpressionSyntax {
            return try! evaluateExpression(p.expression)
        }
        
        throw Exception("Unexpected node \(node.kind)")
    }
}
