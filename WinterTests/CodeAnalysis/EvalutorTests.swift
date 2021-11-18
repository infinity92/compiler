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
        ("{ var a = 0 (a = 10) * a }", 100)
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
        ("3 < 4", true),
        ("5 < 4", false),
        ("4 <= 4", true),
        ("4 <= 5", true),
        ("5 <= 4", false),
        
        ("4 > 3", true),
        ("4 > 5", false),
        ("4 >= 4", true),
        ("5 >= 4", true),
        ("4 >= 5", false),
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

    func testVariableDeclarationReportsRedeclaration() {
        let text = """
            {
                var x = 10
                var y = 100
                {
                    var x = 10
                }
                var [x] = 5
            }
        """
        
        let diagnostics = """
            Variable 'x' is already declared
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testNameReportsUndefined() {
        let text = """
            [x] * 10
        """
        
        let diagnostics = """
            Variable 'x' doesn't exist
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testAssignedReportsUndefined() {
        let text = """
            [x] = 10
        """
        
        let diagnostics = """
            Variable 'x' doesn't exist
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testAssignedReportsCannotAssign() {
        let text = """
            {
                let x = 10
                x [=] 0
            }
        """
        
        let diagnostics = """
            Variable 'x' is read-only and cannot be assigned to
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testAssignedReportsCannotConvert() {
        let text = """
            {
                var x = 10
                x = [true]
            }
        """
        
        let diagnostics = """
            Cannot convert type 'Bool' to 'Int'
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testUnaryReportsUdefined() {
        let text = """
            [+]true
        """
        
        let diagnostics = """
            Unary operator '+' is not defined for type 'Bool'
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testBinaryReportsUdefined() {
        let text = """
            10 [*] false
        """
        
        let diagnostics = """
            Binary operator '*' is not defined for type 'Int' and 'Bool'
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    private func assertHasDiagnostics(_ text: String, _ diagnosticsText: String) throws {
        let annotatedText = try! AnnotatedText.parse(text)
        let syntaxTree = SyntaxTree.parse(annotatedText.text)
        let compilation = Compilation(syntax: syntaxTree)
        let result = compilation.evaluate()
        
        let expectedDiagnostics = AnnotatedText.unindentLines(diagnosticsText)
        
        if  annotatedText.spans.count != expectedDiagnostics.count {
            throw Exception("ERROR: Must mark as many spans as there are expected diagnostics")
        }
        
        XCTAssertEqual(expectedDiagnostics.count, result.diagnostics.toArray().count)
        
        for i in 0..<expectedDiagnostics.count {
            let expectedMessage = expectedDiagnostics[i]
            let actualMessage = result.diagnostics[i].message
            
            XCTAssertEqual(expectedMessage, actualMessage)
            
            let expectedSpan = annotatedText.spans[i]
            let actualSpan = result.diagnostics[i].span
            
            XCTAssertEqual(expectedSpan, actualSpan)
        }
    }
}
