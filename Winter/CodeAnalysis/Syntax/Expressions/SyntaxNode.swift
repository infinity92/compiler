//
//  SyntaxNode.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

public protocol SyntaxNode {
    var kind: SyntaxKind { get }
    func getChildren() -> Array<SyntaxNode>
}

extension SyntaxNode {
    public func getChildren() -> Array<SyntaxNode> {
        var result = Array<SyntaxNode>()
        let mirror = Mirror(reflecting: self)
        for property in mirror.children  {
            if let child = property.value as? SyntaxNode {
                result.append(child)
            } else if let children = property.value as? [SyntaxNode] {
                result.append(contentsOf: children)
            }
        }
        
        return result
    }
}
