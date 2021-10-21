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
    
    let parser = Parser(text: input)
    let expression = parser.parse()
    
    formattedPrint(expression)
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
    indent += isLast ? "    " : "│   "
    
    let lastChildNode = node.getChildren().last
    
    for child in node.getChildren() {
        formattedPrint(child, indent: indent, isLast: (child.kind == lastChildNode?.kind))
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

struct SyntaxToken: SyntaxNode {
    let kind: SyntaxKind
    let position: Int
    let text: String?
    let value: Any?
    
    func getChildren() -> Array<SyntaxNode> {
        return []
    }
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
    case numberExpression
    case binaryExpression
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

class Parser {
    private let tokens: [SyntaxToken]
    private var position: Int = 0
    private var current: SyntaxToken {
        peek(0)
    }
    
    init(text: String) {
        var tokens: [SyntaxToken] = []
        let lexer = Lexer(text: text)
        var token: SyntaxToken
        repeat {
            token = lexer.nextToken()
            
            if token.kind != .whitespaceToken && token.kind != .badToken {
                tokens.append(token)
            }
        } while token.kind != SyntaxKind.endOfFileToken
        
        self.tokens = tokens
        //current = self.tokens[0]
    }
    
    private func peek(_ offset: Int) -> SyntaxToken {
        let index = position + offset
        if index >= tokens.count {
            return tokens[tokens.count - 1]
        }
        
        return tokens[index]
    }
    
    private func nextToken() -> SyntaxToken {
        let current = self.current
        position += 1
        return current
    }
    
    private func match(kind: SyntaxKind) -> SyntaxToken {
        if current.kind == kind {
            return nextToken()
        }
        
        return SyntaxToken(kind: kind, position: current.position, text: nil, value: nil)
    }
    
    func parse() -> ExpressionSyntax {
        var left = parsePrimaryExpression()
        
        while current.kind == .pluseToken || current.kind == .minusToken {
            let operatorToken = nextToken()
            let right = parsePrimaryExpression()
            left = BinaryExpressionSyntax(left: left, operatorToken: operatorToken, right: right)
        }
        
        return left
    }
    
    private func parsePrimaryExpression() -> ExpressionSyntax {
        let numberToken = match(kind: .numberToken)
        return NumberExpressionSyntax(numberToken: numberToken)
    }
}

protocol SyntaxNode {
    var kind: SyntaxKind { get }
    func getChildren() -> Array<SyntaxNode>
}

protocol ExpressionSyntax: SyntaxNode {
    
}

struct NumberExpressionSyntax: ExpressionSyntax {
    let numberToken: SyntaxToken
    var kind: SyntaxKind {
        .numberExpression
    }
    
    func getChildren() -> Array<SyntaxNode> {
        return [numberToken]
    }
}

struct BinaryExpressionSyntax: ExpressionSyntax {
    let left: ExpressionSyntax
    let operatorToken: SyntaxToken
    let right: ExpressionSyntax
    var kind: SyntaxKind {
        .binaryExpression
    }
    
    func getChildren() -> Array<SyntaxNode> {
        return [
            left,
            operatorToken,
            right
        ]
    }
}


