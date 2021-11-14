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
    
    private var start: Int = 0
    private(set) var diagnostics = DiagnosticBag()
    private var kind: SyntaxKind?
    private var value: Any?
    
    private var current: Character {
        return peek(0)
    }
    private var lookahead: Character {
        return peek(1)
    }
    
    init(text: String) {
        self.text = text
    }
    
    private func peek(_ offset: Int) -> Character {
        let index = position + offset
        if index >= text.count {
            return "\0"
        }
        return text.char(at: index)
    }
    
    func lex() -> SyntaxToken {
        start = position
        kind = .badToken
        value = nil
        
        switch current {
        case "\0":
            kind = .endOfFileToken
        case "+":
            kind = .pluseToken
            position += 1
        case "-":
            kind = .minusToken
            position += 1
        case "*":
            kind = .starToken
            position += 1
        case "/":
            kind = .slashToken
            position += 1
        case "(":
            kind = .openParenthesisToken
            position += 1
        case ")":
            kind = .closeParenthesisToken
            position += 1
        case "&":
            if lookahead == "&" {
                kind = .ampersantAmpersantToken
                position += 2
            }
        case "|":
            if lookahead == "|" {
                kind = .pipePipeToken
                position += 2
            }
        case "=":
            position += 1
            if current != "=" {
                kind = .equalsToken
            } else {
                position += 1
                kind = .equalsEqualsToken
            }
        case "!":
            position += 1
            if current != "=" {
                kind = .bangToken
            } else {
                kind = .bangEqualsToken
                position += 1
            }
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            readNumberToken()
        case " ", "\t", "\n", "\r":
            readWhiteSpace()
        default:
            if current.isLetter {
                readIdentifierOrKeyword()
            } else if current.isWhitespace {
                readWhiteSpace()
            } else {
                diagnostics.reportBadCharacter(position, current)
                position += 1
            }
        }
        
        let length = position - start
        var text = SyntaxFacts.getText(kind: kind!)
        if text == nil {
            text = self.text.substring(start, offset: length)
        }
        
        return SyntaxToken(kind: kind!, position: start, text: text, value: value)
    }
    
    private func readNumberToken() {
        while current.isNumber {
            position += 1
        }
        let length = position - start
        let substring = text.substring(start, offset: length)
        value = Int(substring)
        if value == nil {
            diagnostics.reportInvalidNumber(TextSpan(start: start, length: length), text, Int.self)
        }
        
        kind = .numberToken
    }
    
    private func readWhiteSpace() {
        while current.isWhitespace {
            position += 1
        }
        kind = .whitespaceToken
    }
    
    private func readIdentifierOrKeyword() {
        while current.isLetter {
            position += 1
        }
        let length = position - start
        let substring = text.substring(start, offset: length)
        kind = SyntaxFacts.getKeywordKind(text: substring)
    }
}
