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
            let expression = SyntaxTree.parse(text).root
            
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
    
    static func getBinaryOperatorPairsData() -> [(SyntaxKind, SyntaxKind)] {
        var data: [(SyntaxKind, SyntaxKind)] = []
        SyntaxFacts.getBinaryOperatorKinds().forEach {operator1 in
            SyntaxFacts.getBinaryOperatorKinds().forEach {operator2 in
                data.append((operator1, operator2))
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
