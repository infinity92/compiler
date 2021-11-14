//
//  SyntaxNode.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

public protocol SyntaxNode {
    var kind: SyntaxKind { get }
    var span: TextSpan { get }
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
    
    public var span: TextSpan {
        let first = getChildren().first!.span
        let last = getChildren().last!.span
        return TextSpan.fromBounds(first.start, last.end)
    }
}
