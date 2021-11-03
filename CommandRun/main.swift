//
//  main.swift
//  compiler
//
//  Created by Александр Котляров on 16.10.2021.
//

import Foundation
import Winter

var showTree = false
var variables: [VariableSymbol: Any] = [:]

while true {
    print(">", terminator: " ")
    guard let input = readLine() else {
        continue
    }
    
    if input == "#exit" {
        break
    }
    
    if (input == "#showTree") {
        showTree = !showTree
        print(showTree ? "Showing parse trees" : "Not showing parse")
        continue
    }
    
    let syntaxTree = SyntaxTree.parse(input)
    let compilation = Compilation(syntax: syntaxTree)
    let result = compilation.evaluate()
    let diagnostics = result.diagnostics
    
    if showTree {
        formattedPrint(syntaxTree.root)
    }
    
    if !diagnostics.isEmpty {
        for diagnostic in diagnostics {
            
            print(diagnostic)
            
            let prefix = input.substring(0, offset: diagnostic.span.start)
            let error = input.substring(diagnostic.span.start, offset: diagnostic.span.length)
            let suffix = input.substring(diagnostic.span.end, offset: input.count - diagnostic.span.end)
            
            print(prefix, terminator: "")
            print(error, terminator: "")
            print(suffix)
            for index in 0...diagnostic.span.start {
                if index == diagnostic.span.start {
                    print("^", terminator: "")
                } else {
                    print("-", terminator: "")
                }
                
            }
            print("")
            
        }
    } else {
        print(result.value ?? "")
    }
}

func formattedPrint(_ node: SyntaxNode, indent: String = "", isLast: Bool = true) {
    var indent = indent
    let marker = isLast ? "└──" : "├──";
    print(indent, terminator: "")
    print(marker, terminator: "")
    print(node.kind, terminator: "")
    if let node = node as? SyntaxToken, node.value != nil {
        print(" \(node.value ?? "")", terminator: "")
    }
    print("")
    indent += isLast ? "   " : "│   "
    
    let lastChildNode = node.getChildren().last
    
    for child in node.getChildren() {
        formattedPrint(child, indent: indent, isLast: (child.kind == lastChildNode?.kind))
    }
}








