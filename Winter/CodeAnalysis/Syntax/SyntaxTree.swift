//
//  SyntaxTree.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

public struct SyntaxTree {
    public let root: ExpressionSyntax
    let endOfFileToken: SyntaxToken
    var diagnostics: DiagnosticBag
    
    public static func parse(_ text: String) -> SyntaxTree {
        let parser = Parser(text: text)
        return parser.parse()
    }
    
    public static func parseTokens(_ text: String) -> [SyntaxToken] {
        let lexer = Lexer(text: text)
        var tokens: [SyntaxToken] = []
        while true {
            let token = lexer.lex()
            if token.kind == .endOfFileToken {
                break
            }
            
            tokens.append(token)
        }
        
        return tokens
    }
}
