//
//  SyntaxTree.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

struct SyntaxTree {
    let root: ExpressionSyntax
    let endOfFileToken: SyntaxToken
    let diagnostics: [String]
    
    static func parse(_ text: String) -> SyntaxTree {
        let parser = Parser(text: text)
        return parser.parse()
    }
}
