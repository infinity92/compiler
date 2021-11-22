//
//  BoundNode.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

protocol BoundNode {
    var kind: BoundNodeKind { get }
}

extension BoundNode {
    public func getChildren() -> Array<BoundNode> {
        var result = Array<BoundNode>()
        let mirror = Mirror(reflecting: self)
        for property in mirror.children  {
            if let child = property.value as? BoundNode {
                result.append(child)
            } else if let children = property.value as? [BoundNode] {
                result.append(contentsOf: children)
            }
        }
        
        return result
    }
    
    public func writeTo() {
        formattedPrint(self)
    }
    
    private func formattedPrint(_ node: BoundNode, indent: String = "", isLast: Bool = true) {
        var indent = indent
        let marker = isLast ? "└──" : "├──";
        print(indent, terminator: "")
        print(marker, terminator: "")
        
        print(getColor(by: node).rawValue, terminator: "")
        //writeProperties(for: node)
        
        let text = getText(for: node)
        print(text, terminator: "")
        
        var isFirstProperty = true
        
        node.getProperties().forEach { (name, value) in
            if isFirstProperty {
                isFirstProperty = false
            } else {
                print(TerminalColor.magenta.rawValue, terminator: "")
                print(",", terminator: "")
            }
            print(" ", terminator: "")
            print(TerminalColor.yellow.rawValue, terminator: "")
            print(name, terminator: "")
            print(TerminalColor.magenta.rawValue, terminator: "")
            print(" = ", terminator: "")
            print(TerminalColor.blue.rawValue, terminator: "")
            print(value, terminator: "")
        }
        
        print(TerminalColor.default.rawValue, terminator: "")
        
        print("")
        indent += isLast ? "   " : "│   "
        
        let lastChildNode = node.getChildren().last
        
        for child in node.getChildren() {
            formattedPrint(child, indent: indent, isLast: (child.kind == lastChildNode?.kind))
        }
    }
    
    private func getProperties() -> Array<(String, Any)> {
        var result = Array<(String, Any)>()
        let mirror = Mirror(reflecting: self)
        for property in mirror.children  {
            
            if property.label == String(describing: kind) ||
                property.label == "op" {
                continue
            }
            
            if property.value is BoundNode || property.value is [BoundNode] {
                continue
            }
            
            result.append((property.label!, property.value))
        }
        
        return result
    }
    
    private func getColor(by node: BoundNode) -> TerminalColor {
        if node is BoundExpression {
            return .blue
        }
        if node is BoundStatement {
            return .cyan
        }
        
        return .yellow
    }
    
    private func getText(for node: BoundNode) -> String {
        if let b = node as? BoundBinaryExpression {
            return String(describing: b.op.kind) + "Expression"
        }
        if let u = node as? BoundUnaryExpression {
            return String(describing: u.op.kind) + "Expression"
        }
        
        return String(describing: node.kind)
    }
    
    public func toString() {
        writeTo()
    }
}
