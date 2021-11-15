//
//  SyntaxTree.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

public struct SyntaxTree {
    public let text: SourceText
    public let root: ExpressionSyntax
    let endOfFileToken: SyntaxToken
    var diagnostics: DiagnosticBag
    
    public static func parse(_ text: String) -> SyntaxTree {
        let sourceText = SourceText.from(text: text)
        return SyntaxTree.parse(sourceText)
        
    }
    
    public static func parse(_ text: SourceText) -> SyntaxTree {
        let parser = Parser(text: text)
        return parser.parse()
    }
    
    public static func parseTokens(_ text: String) -> [SyntaxToken] {
        let sourceText = SourceText.from(text: text)
        return parseTokens(sourceText)
    }
    
    public static func parseTokens(_ text: SourceText) -> [SyntaxToken] {
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
