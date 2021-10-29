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
        peek(0)
    }
    private var lookahead: Character {
        peek(1)
    }
    
    init(text: String) {
        self.text = text
    }
    
    private func peek(_ offset: Int) -> Character {
        let index = position + offset
        if index >= text.count {
            return "\0"
        }
        return text.char(at: position)
    }
    
    func lex() -> SyntaxToken {
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
        
        if current.isLetter {
            let start = position
            while current.isLetter {
                next()
            }
            let length = position - start
            let substring = text.substring(start, offset: length)
            let kind = SyntaxFacts.getKeywordKind(text: substring)
            return SyntaxToken(kind: kind, position: start, text: substring, value: nil)
        }
        
        switch current {
        case "+":
            next()
            return SyntaxToken(kind: .pluseToken, position: position, text: "+", value: nil)
        case "-":
            next()
            return SyntaxToken(kind: .minusToken, position: position, text: "-", value: nil)
        case "*":
            next()
            return SyntaxToken(kind: .starToken, position: position, text: "*", value: nil)
        case "/":
            next()
            return SyntaxToken(kind: .slashToken, position: position, text: "/", value: nil)
        case "(":
            next()
            return SyntaxToken(kind: .openParenthesisToken, position: position, text: "(", value: nil)
        case ")":
            next()
            return SyntaxToken(kind: .closeParenthesisToken, position: position, text: ")", value: nil)
        case "&":
            if lookahead == "&" {
                next()
                next()
                return SyntaxToken(kind: .ampersantAmpersantToken, position: position, text: "&&", value: nil)
            }
        case "|":
            if lookahead == "|" {
                next()
                next()
                return SyntaxToken(kind: .pipePipeToken, position: position, text: "||", value: nil)
            }
        case "=":
            if lookahead == "=" {
                next()
                next()
                return SyntaxToken(kind: .equalsEqualsToken, position: position, text: "==", value: nil)
            }
        case "!":
            if lookahead == "=" {
                next()
                next()
                return SyntaxToken(kind: .bangEqualsToken, position: position, text: "!=", value: nil)
            } else {
                next()
                return SyntaxToken(kind: .bangToken, position: position, text: "!", value: nil)
            }
        default:
            diagnostics.append("ERROR: bad character input: \(current)")
        }
        
        next()
        return SyntaxToken(kind: .badToken, position: position, text: text.substring(position-1,offset: 1), value: nil)
    }
    
    private func next() {
        position += 1
    }
}
