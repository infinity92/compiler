//
//  main.swift
//  compiler
//
//  Created by Александр Котляров on 16.10.2021.
//

import Foundation

while true {
    print(">", terminator: " ")
    guard let input = readLine() else {
        continue
    }
    
    if input == "exit" {
        break
    }
    
    let lexer = Lexer(text: input)
    while true {
        let token = lexer.nextToken()
        if token.kind == .endOfFileToken {
            break
        }
        print("\(token.kind): \(token.text)", terminator: " ")
        if token.value != nil {
            print("\(token.value ?? "")")
        }
        
        print("")
    }
}

class Lexer {
    private let text: String
    private var position: Int = 0
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
        
        next()
        return SyntaxToken(kind: .badToken, position: position, text: text.substring(position-1,offset: 1), value: nil)
    }
    
    private func next() {
        position += 1
    }
}

struct SyntaxToken {
    let kind: SyntaxKind
    let position: Int
    let text: String
    let value: Any?
}

enum SyntaxKind {
    case numberToken
    case pluseToken
    case whitespaceToken
    case minusToken
    case starToken
    case slashToken
    case openParenthesisToken
    case closeParenthesisToken
    case badToken
    case endOfFileToken
}


extension String {
    func substring(_ r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ..< end])
    }
    
    func substring(_ start: Int, offset: Int) -> String {
        let start = index(startIndex, offsetBy: start)
        let end = index(start, offsetBy: offset)
        return String(self[start ..< end])
    }
    
    func char(at index:Int) -> Character {
        let i = self.index(startIndex, offsetBy: index)
        return self[i]
    }
}
