//
//  SyntaxTree.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

public struct SyntaxTree {
    public let text: SourceText
    public let root: CompilationUnitSyntax
    public var diagnostics: DiagnosticBag
    
    private init(text: SourceText) {
        let parser = Parser(text: text)
        let root = parser.parseCompilationUnit()
        let diagnostics = parser.diagnostics
        
        self.text = text
        self.diagnostics = diagnostics
        self.root = root
    }
    
    public static func parse(_ text: String) -> SyntaxTree {
        let sourceText = SourceText.from(text: text)
        return SyntaxTree.parse(sourceText)
        
    }
    
    public static func parse(_ text: SourceText) -> SyntaxTree {
        return SyntaxTree(text: text)
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
