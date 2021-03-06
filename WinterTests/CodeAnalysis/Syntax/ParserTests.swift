//
//  ParserTests.swift
//  WinterTests
//
//  Created by Александр Котляров on 09.11.2021.
//

import XCTest
@testable import Winter

class ParserTests: XCTestCase {
    func testBinaryExpressionHonorsPrecedences() {
        ParserTests.getBinaryOperatorPairsData().forEach { (op1, op2) in
            let op1Precedence = op1.getBinaryOperatorPrecedence()
            let op2Precedence = op2.getBinaryOperatorPrecedence()
            let op1Text = SyntaxFacts.getText(kind: op1)
            let op2Text = SyntaxFacts.getText(kind: op2)
            let text = "a \(op1Text ?? "") b \(op2Text ?? "") c"
            let expression = ParserTests.parseExpression(text: text)
            
            if op1Precedence >= op2Precedence {
                var e = AssertingEnumerator(expression)
                e.assertNode(.binaryExpression)
                e.assertNode(.binaryExpression)
                e.assertNode(.nameExpression)
                e.assertToken(.identifierToken, "a")
                e.assertToken(op1, op1Text!)
                e.assertNode(.nameExpression)
                e.assertToken(.identifierToken, "b")
                e.assertToken(op2, op2Text!)
                e.assertNode(.nameExpression)
                e.assertToken(.identifierToken, "c")
            } else {
                var e = AssertingEnumerator(expression)
                e.assertNode(.binaryExpression)
                e.assertNode(.nameExpression)
                e.assertToken(.identifierToken, "a")
                e.assertToken(op1, op1Text!)
                e.assertNode(.binaryExpression)
                e.assertNode(.nameExpression)
                e.assertToken(.identifierToken, "b")
                e.assertToken(op2, op2Text!)
                e.assertNode(.nameExpression)
                e.assertToken(.identifierToken, "c")
            }
        }
    }
    
    func testUnaryExpressionHonorsPrecedences() {
        ParserTests.getUnaryOperatorPairsData().forEach { (unaryKind, binaryKind) in
            let unaryPrecedence = unaryKind.getUnaryOperatorPrecedence()
            let binaryPrecedence = binaryKind.getBinaryOperatorPrecedence()
            let unaryText = SyntaxFacts.getText(kind: unaryKind)
            let binaryText = SyntaxFacts.getText(kind: binaryKind)
            let text = "\(unaryText ?? "") a \(binaryText ?? "") b"
            let expression = ParserTests.parseExpression(text: text)
            
            if unaryPrecedence >= binaryPrecedence {
                var e = AssertingEnumerator(expression)
                e.assertNode(.binaryExpression)
                e.assertNode(.unaryExpression)
                e.assertToken(unaryKind, unaryText!)
                e.assertNode(.nameExpression)
                e.assertToken(.identifierToken, "a")
                e.assertToken(binaryKind, binaryText!)
                e.assertNode(.nameExpression)
                e.assertToken(.identifierToken, "b")
            } else {
                var e = AssertingEnumerator(expression)
                e.assertNode(.unaryExpression)
                e.assertToken(unaryKind, unaryText!)
                e.assertNode(.binaryExpression)
                e.assertNode(.nameExpression)
                e.assertToken(.identifierToken, "a")
                e.assertToken(binaryKind, binaryText!)
                e.assertNode(.nameExpression)
                e.assertToken(.identifierToken, "b")
            }
        }
    }
    
    private static func parseExpression(text: String) -> ExpressionSyntax {
        let syntaxTree = SyntaxTree.parse(text)
        let root = syntaxTree.root
        let statement = root.statement
        return (statement as! ExpressionStatementSyntax).expression
    }
    
    static func getBinaryOperatorPairsData() -> [(SyntaxKind, SyntaxKind)] {
        var data: [(SyntaxKind, SyntaxKind)] = []
        SyntaxFacts.getBinaryOperatorKinds().forEach {operator1 in
            SyntaxFacts.getBinaryOperatorKinds().forEach {operator2 in
                data.append((operator1, operator2))
            }
        }
        
        return data
    }
    
    static func getUnaryOperatorPairsData() -> [(SyntaxKind, SyntaxKind)] {
        var data: [(SyntaxKind, SyntaxKind)] = []
        SyntaxFacts.getUnaryOperatorKinds().forEach {unary in
            SyntaxFacts.getBinaryOperatorKinds().forEach {binary in
                data.append((unary, binary))
            }
        }
        
        return data
    }
    
    struct AssertingEnumerator {
        private(set) var enumerator: [SyntaxNode]
        private var index = 0
        init(_ node: SyntaxNode) {
            enumerator = AssertingEnumerator.flatten(node)
        }
        
        private static func flatten(_ node: SyntaxNode) -> [SyntaxNode] {
            var result = [SyntaxNode]()
            var stack = [SyntaxNode]()
            stack.append(node)
            while stack.count > 0 {
                let n = stack.popLast()!
                result.append(n)
                
                n.getChildren().reversed().forEach({ node in
                    stack.append(node)
                })
            }
            
            return result
        }
        
        mutating func assertNode(_ kind: SyntaxKind) {
            if enumerator.count < index {
                XCTFail()
            } else {
                let token = enumerator[index]
                //let token = item as! SyntaxToken
                XCTAssertNotNil(token)
                XCTAssertEqual(kind, token.kind)
                index += 1
            }
        }
        
        mutating func assertToken(_ kind: SyntaxKind, _ text: String) {
            if enumerator.count < index {
                XCTFail()
            } else {
                let item = enumerator[index]
                let token = item as! SyntaxToken
                XCTAssertNotNil(token)
                XCTAssertEqual(kind, token.kind)
                XCTAssertEqual(text, token.text)
                index += 1
            }
        }
    }
}
