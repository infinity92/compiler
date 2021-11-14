//
//  SyntaxFacts.swift
//  compiler
//
//  Created by Александр Котляров on 28.10.2021.
//

import Foundation

class SyntaxFacts {
    static func getKeywordKind(text: String) -> SyntaxKind {
        switch (text) {
        case "true":
            return .trueKeyword
        case "false":
            return .falseKeyword
        default:
            return .identifierToken
        }
    }
    
    static func getText(kind: SyntaxKind) -> String? {
        switch kind {
        case .pluseToken:
            return "+"
        case .minusToken:
            return  "-"
        case .starToken:
            return  "*"
        case .slashToken:
            return  "/"
        case .openParenthesisToken:
            return  "("
        case .closeParenthesisToken:
            return  ")"
        case .bangToken:
            return  "!"
        case .ampersantAmpersantToken:
            return "&&"
        case .pipePipeToken:
            return "||"
        case .equalsEqualsToken:
            return "=="
        case .bangEqualsToken:
            return "!="
        case .equalsToken:
            return  "="
        case .trueKeyword:
            return "true"
        case .falseKeyword:
            return "false"
        default:
            return nil
        }
    }
    
    public static func getBinaryOperatorKinds() -> [SyntaxKind] {
        var binaryOperators: [SyntaxKind] = []
        for kind in SyntaxKind.allCases {
            if kind.getBinaryOperatorPrecedence() > 0 {
                binaryOperators.append(kind)
            }
        }
        
        return binaryOperators
    }
    
    public static func getUnaryOperatorKinds() -> [SyntaxKind] {
        var unaryOperators: [SyntaxKind] = []
        for kind in SyntaxKind.allCases {
            if kind.getUnaryOperatorPrecedence() > 0 {
                unaryOperators.append(kind)
            }
        }
        
        return unaryOperators
    }
}