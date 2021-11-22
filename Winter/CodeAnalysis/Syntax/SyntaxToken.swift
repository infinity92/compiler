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
    public var span: TextSpan {
        TextSpan(start: position, length: text?.count ?? 0)
    }
}


extension SyntaxToken: Equatable {
    public static func == (lhs: SyntaxToken, rhs: SyntaxToken) -> Bool {
        lhs.kind == rhs.kind
        && lhs.text == rhs.text
        && lhs.position == rhs.position
        && type(of:lhs.value) == type(of:rhs.value)
        && lhs.span == rhs.span
    }
    
    
}
