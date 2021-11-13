//
//  EvalutorTests.swift
//  WinterTests
//
//  Created by Александр Котляров on 13.11.2021.
//

import XCTest
@testable import Winter

class EvalutorTests: XCTestCase {
    
    private var dataNumber:[(String, Int)] = [
        ("1", 1),
        ("+1", 1),
        ("-1", -1),
        ("14 + 12", 26),
        ("12 - 3", 9),
        ("4 * 2", 8),
        ("9 / 3", 3),
        ("(10)", 10),
        ("(a = 10) * a", 100)
    ]
    
    private var dataBool:[(String, Bool)] = [
        ("12 == 3", false),
        ("3 == 3", true),
        ("12 != 3", true),
        ("3 != 3", false),
        ("false == false", true),
        ("true == false", false),
        ("false != false", false),
        ("true != false", true),
        ("true", true),
        ("false", false),
        ("!true", false),
        ("!false", true),
    ]
    
    func testGetTextRoundTrips() {
        dataNumber.forEach { (text, expectedValue) in
            assertEvaluateResult(text, expectedValue)
        }
        dataBool.forEach { (text, expectedValue) in
            assertEvaluateResult(text, expectedValue)
        }
    }
    
    private func assertEvaluateResult<T: Equatable>(_ text: String, _ expectedValue: T) {
        let syntaxTree = SyntaxTree.parse(text)
        let compilation = Compilation(syntax: syntaxTree)
        let result = compilation.evaluate()
        
        XCTAssert(result.diagnostics.isEmpty)
        XCTAssertEqual(expectedValue, result.value as! T)
    }

}
