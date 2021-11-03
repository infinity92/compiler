//
//  WinterTests.swift
//  WinterTests
//
//  Created by Александр Котляров on 03.11.2021.
//

import XCTest
@testable import Winter

class LexerTests: XCTestCase {
    
    var dataTokens: [(SyntaxKind, String)] = []

    override func setUpWithError() throws {
        dataTokens = [
            (SyntaxKind.identifierToken, "a"),
            (SyntaxKind.identifierToken, "abc")
        ]
    }

    override func tearDownWithError() throws {
        dataTokens = []
    }

    func testLexesToken() throws {
        dataTokens.forEach { (kind, text) in
            let tokens = SyntaxTree.parseTokens(text)
            let token = try! XCTUnwrap(tokens.first)
            XCTAssertEqual(kind, token.kind)
            XCTAssertEqual(text, token.text)
        }
        
    }


}
