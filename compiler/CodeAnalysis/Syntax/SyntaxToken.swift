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
    var span: TextSpan {
        TextSpan(start: position, length: text?.count ?? 0)
    }
    
    func getChildren() -> Array<SyntaxNode> {
        return []
    }
}
