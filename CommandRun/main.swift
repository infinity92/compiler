//
//  main.swift
//  compiler
//
//  Created by Александр Котляров on 16.10.2021.
//

import Foundation
import Winter

var showTree = false
var textBuilder = String()
var previous: Compilation? = nil

while true {
    if textBuilder.count == 0 {
        print("> ", terminator: " ")
    } else {
        print("| ", terminator: " ")
    }
    
    let input = readLine() ?? ""
    let isBlank = input.trimmingCharacters(in: .whitespaces).isEmpty
    
    if textBuilder.count == 0
    {
        if isBlank {
            break
        } else if (input == "#showTree") {
            showTree = !showTree
            print(showTree ? "Showing parse trees" : "Not showing parse")
            continue
        } else if (input == "#reset") {
            previous = nil
            continue
        }
    }
    
    textBuilder += input + "\n"
    let text = textBuilder
    
    let syntaxTree = SyntaxTree.parse(text)
    
    if !isBlank && !syntaxTree.diagnostics.isEmpty {
        continue
    }
    
    let compilation = previous == nil ? Compilation(syntax: syntaxTree) : previous!.continueWith(syntaxTree: syntaxTree)
    
    
    let result = compilation.evaluate()
    let diagnostics = result.diagnostics
    
    if showTree {
        syntaxTree.root.writeTo()
    }
    
    if !diagnostics.isEmpty {
        for diagnostic in diagnostics {
            let lineIndex = syntaxTree.text.getLineIndex(by: diagnostic.span.start)
            let line = syntaxTree.text.lines[lineIndex]
            let lineNumber = lineIndex + 1
            let character = diagnostic.span.start - line.start + 1
            
            print("(\(lineNumber), \(character)): ", terminator: "")
            
            print(diagnostic)
            
            let prefixSpan = TextSpan.fromBounds(line.start, diagnostic.span.start)
            let suffixSpan = TextSpan.fromBounds(diagnostic.span.end, line.end)
            
            let prefix = syntaxTree.text.toString(prefixSpan)
            let error = syntaxTree.text.toString(diagnostic.span)
            //let suffix = syntaxTree.text.toString(diagnostic.span.end, offset: line.end) //input.count - diagnostic.span.end
            let suffix = syntaxTree.text.toString(suffixSpan)
            
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
        previous = compilation
    }
    
    textBuilder = ""
}








