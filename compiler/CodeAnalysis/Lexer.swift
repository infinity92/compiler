//
//  Lexer.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

class Lexer {
    private let text: String
    private var position: Int = 0
    private(set) var diagnostics: [String] = []
    private var current: Character {
        get {
            if position >= text.count {
                return "\0"
            }
            return text.char(at: position)
        }
    }
    
    init(text: String) {
        self.text = text
    }
    
    func nextToken() -> SyntaxToken {
        if position >= text.count {
            return SyntaxToken(kind: .endOfFileToken, position: position, text: "\0", value: nil)
        }
        if current.isNumber {
            let start = position
            while current.isNumber {
                next()
            }
            let length = position - start
            let substring = text.substring(start, offset: length)
            let value = Int(substring)
            if value == nil {
                diagnostics.append("The number \(substring) cannot be represented by a Int")
            }
            
            return SyntaxToken(kind: .numberToken, position: start, text: substring, value: value)
        }
        
        if current.isWhitespace {
            let start = position
            while current.isWhitespace {
                next()
            }
            let length = position - start
            let substring = text.substring(start, offset: length)
            
            return SyntaxToken(kind: .whitespaceToken, position: start, text: substring, value: nil)
        }
        
        if current == "+" {
            next()
            return SyntaxToken(kind: .pluseToken, position: position, text: "+", value: nil)
        } else if current == "-" {
            next()
            return SyntaxToken(kind: .minusToken, position: position, text: "-", value: nil)
        } else if current == "*" {
            next()
            return SyntaxToken(kind: .starToken, position: position, text: "*", value: nil)
        } else if current == "/" {
            next()
            return SyntaxToken(kind: .slashToken, position: position, text: "/", value: nil)
        } else if current == "(" {
            next()
            return SyntaxToken(kind: .openParenthesisToken, position: position, text: "(", value: nil)
        } else if current == ")" {
            next()
            return SyntaxToken(kind: .closeParenthesisToken, position: position, text: ")", value: nil)
        }
        
        diagnostics.append("ERROR: bad character input: \(current)")
        next()
        return SyntaxToken(kind: .badToken, position: position, text: text.substring(position-1,offset: 1), value: nil)
    }
    
    private func next() {
        position += 1
    }
}
