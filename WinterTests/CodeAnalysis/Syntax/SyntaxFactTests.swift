//
//  SyntaxFactTests.swift
//  WinterTests
//
//  Created by Александр Котляров on 09.11.2021.
//

import XCTest
@testable import Winter

class SyntaxFactTests: XCTestCase {
    func testGetTextRoundTrips() {
        for kind in SyntaxKind.allCases {
            guard let text = SyntaxFacts.getText(kind: kind) else {
                continue
            }
            
            let tokens = SyntaxTree.parseTokens(text)
            let token = try! XCTUnwrap(tokens.first)
            XCTAssertEqual(kind, token.kind)
            XCTAssertEqual(text, token.text)
        }
    }
}
