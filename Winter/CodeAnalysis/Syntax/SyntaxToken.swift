//
//  SyntaxToken.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

public struct SyntaxToken: SyntaxNode {
    public let kind: SyntaxKind
    let position: Int
    let text: String?
    public let value: Any?
    var span: TextSpan {
        TextSpan(start: position, length: text?.count ?? 0)
    }
    
    public func getChildren() -> Array<SyntaxNode> {
        return []
    }
}
