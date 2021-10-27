//
//  SyntaxToken.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

struct SyntaxToken: SyntaxNode {
    let kind: SyntaxKind
    let position: Int
    let text: String?
    let value: Any?
    
    func getChildren() -> Array<SyntaxNode> {
        return []
    }
}
