//
//  SyntaxNode.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

protocol SyntaxNode {
    var kind: SyntaxKind { get }
    func getChildren() -> Array<SyntaxNode>
}
