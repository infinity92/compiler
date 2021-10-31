//
//  main.swift
//  compiler
//
//  Created by Александр Котляров on 16.10.2021.
//

import Foundation

var showTree = false

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
    let binder = Binder()
    let boudeExpression = try! binder.bindExpression(syntax: syntaxTree.root)
    
    let diagnostics = syntaxTree.diagnostics + binder.diagnostics
    
    if showTree {
        formattedPrint(syntaxTree.root)
    }
    
    if !diagnostics.isEmpty {
        for diagnostic in diagnostics {
            print(diagnostic)
        }
    } else {
        let evaluator = Evaluator(root: boudeExpression)
        let result = evaluator.evaluate()
        print(result)
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








