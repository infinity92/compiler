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
    var dataSeparators : [(SyntaxKind, String)] = []
    
    override func setUpWithError() throws {
        let fixedTokens = SyntaxKind.allCases.filter { kind in
            SyntaxFacts.getText(kind: kind) != nil
        }.map { kind in
                return (kind, SyntaxFacts.getText(kind: kind)!)
            }
        
        dataTokens = fixedTokens + [
            (SyntaxKind.identifierToken, "a"),
            (SyntaxKind.identifierToken, "abc"),
            (SyntaxKind.numberToken, "1"),
            (SyntaxKind.numberToken, "123"),
        ]
        
        dataSeparators = [
            (SyntaxKind.whitespaceToken, " "),
            (SyntaxKind.whitespaceToken, "  "),
            (SyntaxKind.whitespaceToken, "\r"),
            (SyntaxKind.whitespaceToken, "\n"),
            (SyntaxKind.whitespaceToken, "\r\n"),
        ]
    }

    override func tearDownWithError() throws {
        dataTokens = []
        dataSeparators = []
    }
    
    func testLexesAllTokens() throws {
        let tokenKinds = SyntaxKind.allCases.filter { kind in
            String(describing: kind).hasSuffix("Keyword") || String(describing: kind).hasSuffix("Token")
        }
        let testedTokenKinds = (dataTokens + dataSeparators).map { $0.0 }
        var untestedTokenKinds = tokenKinds.filter { !testedTokenKinds.contains($0) }
        untestedTokenKinds = untestedTokenKinds.filter { $0 != .badToken && $0 != .endOfFileToken}
        
        XCTAssert(untestedTokenKinds.isEmpty)
    }

    func testLexesToken() throws {
        (dataTokens + dataSeparators).forEach { (kind, text) in
            let tokens = SyntaxTree.parseTokens(text)
            let token = try! XCTUnwrap(tokens.first)
            XCTAssertEqual(kind, token.kind)
            XCTAssertEqual(text, token.text)
        }
    }
    
    private static func requiresSaparator(_ kind1: SyntaxKind, _ kind2: SyntaxKind) -> Bool {
        let t1IsKeywords = String(describing: kind1).hasSuffix("Keyword")
        let t2IsKeywords = String(describing: kind2).hasSuffix("Keyword")
        
        if kind1 == .identifierToken && kind2 == .identifierToken {
            return true
        }
        if t1IsKeywords && t2IsKeywords {
            return true
        }
        if t1IsKeywords && kind2 == .identifierToken {
            return true
        }
        if kind1 == .identifierToken && t2IsKeywords {
            return true
        }
        if kind1 == .numberToken && kind2 == .numberToken {
            return true
        }
        if kind1 == .bangToken && kind2 == .equalsToken {
            return true
        }
        if kind1 == .bangToken && kind2 == .equalsEqualsToken {
            return true
        }
        if kind1 == .equalsToken && kind2 == .equalsToken {
            return true
        }
        if kind1 == .equalsToken && kind2 == .equalsEqualsToken {
            return true
        }
        
        return false
    }
    
    func testLexesTokenPairs() throws {
        getTokenPairs().forEach { (kind1, text1, kind2, text2) in
            let text = text1 + text2
            let tokens = SyntaxTree.parseTokens(text)
            XCTAssertEqual(2, tokens.count)
            XCTAssertEqual(tokens[0].kind, kind1)
            XCTAssertEqual(tokens[0].text, text1)
            XCTAssertEqual(tokens[1].kind, kind2)
            XCTAssertEqual(tokens[1].text, text2)

        }
    }
    
    func testLexesTokenPairsWithSeparator() throws {
        getTokenPairsWithSeparator().forEach { (kind1, text1, separatorKind, saparatorText, kind2, text2) in
            let text = text1 + saparatorText + text2
            let tokens = SyntaxTree.parseTokens(text)
            XCTAssertEqual(3, tokens.count)
            XCTAssertEqual(tokens[0].kind, kind1)
            XCTAssertEqual(tokens[0].text, text1)
            XCTAssertEqual(tokens[1].kind, separatorKind)
            XCTAssertEqual(tokens[1].text, saparatorText)
            XCTAssertEqual(tokens[2].kind, kind2)
            XCTAssertEqual(tokens[2].text, text2)

        }
    }

    private func getTokenPairs() -> [(SyntaxKind, String, SyntaxKind, String)] {
        var tokenPairs: [(SyntaxKind, String, SyntaxKind, String)] = []
        dataTokens.forEach { t1 in
            dataTokens.forEach { t2 in
                if !LexerTests.requiresSaparator(t1.0, t2.0) {
                    tokenPairs.append((t1.0, t1.1, t2.0, t2.1))
                }
            }
        }
        
        return tokenPairs
    }
    
    private func getTokenPairsWithSeparator() -> [(SyntaxKind, String, SyntaxKind, String, SyntaxKind, String)] {
        var tokenPairsWithSeparator: [(SyntaxKind, String, SyntaxKind, String, SyntaxKind, String)] = []
        dataTokens.forEach { t1 in
            dataTokens.forEach { t2 in
                if LexerTests.requiresSaparator(t1.0, t2.0) {
                    dataSeparators.forEach { s in
                        tokenPairsWithSeparator.append((t1.0, t1.1, s.0, s.1, t2.0, t2.1))
                    }
                }
            }
        }
        
        return tokenPairsWithSeparator
    }
}
