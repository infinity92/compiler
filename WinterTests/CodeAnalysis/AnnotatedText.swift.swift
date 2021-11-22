//
//  AnnotatedText.swift.swift
//  WinterTests
//
//  Created by Александр Котляров on 18.11.2021.
//

import Foundation
import Winter

struct AnnotatedText {
    public let text: String
    public let spans: [TextSpan]
    
    public static func parse(_ text: String) throws -> AnnotatedText {
        let text = unident(text)
        var textBuilder = ""
        var spanBuilder = [TextSpan]()
        var startStack = [Int]()
        
        var position = 0
        
        try! text.forEach { c in
            if c == "[" {
                startStack.append(position)
            } else if c == "]" {
                if startStack.count == 0 {
                    throw Exception("Too many ']' in text")
                }
                
                let start = startStack.popLast()
                let end = position
                let span = TextSpan.fromBounds(start!, end)
                spanBuilder.append(span)
            } else {
                position += 1
                textBuilder += String(c)
            }
        }
        
        if startStack.count != 0 {
            throw Exception("Missing ']' in text")
        }
        
        return AnnotatedText(text: textBuilder, spans: spanBuilder)
    }
    
    public static func unindentLines(_ text: String) -> [String] {
        var lines = text.split(separator: "\n").map({ substring in
            String(substring)
        })
        
        var minIndentation = Int.max
        for i in 0..<lines.count {
            let line = lines[i]
            if line.trimmingCharacters(in: .whitespaces).count == 0 {
                lines[i] = ""
                continue
            }
            
            let identation = line.count - line.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression).count
            minIndentation = min(minIndentation, identation)
        }
        
        for i in 0..<lines.count {
            if lines[i].count == 0 {
                continue
            }
            lines[i] = lines[i].substring(minIndentation)
        }
        
        while lines.count > 0 && lines[0].count == 0 {
            lines.remove(at: 0)
        }
        
        while lines.count > 0 && lines[lines.count - 1].count == 0 {
            lines.remove(at: lines.count - 1)
        }
        
        return lines
    }
    
    public static func unident(_ text: String) -> String {
        let lines = unindentLines(text)
        return lines.joined(separator: "\n")
    }
}
