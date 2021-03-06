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
        ("var a = 10", 10),
        ("{ var a = 10 (a * a) }", 100),
        ("{ var a = 0 (a = 10) * a }", 100),
        ("{ var a = 0 if a == 0 a = 10 a }", 10),
        ("{ var a = 0 if a == 4 a = 10 a }", 0),
        ("{ var a = 0 if a == 0 a = 10 else a = 5 a }", 10),
        ("{ var a = 0 if a == 4 a = 10 else a = 5 a }", 5),
        ("{ var i = 10 var result = 0 while i > 0 { result = result + i i = i - 1 } result }", 55),
        ("{ var result = 0 for i = 1 to 10 { result = result + i } result }", 55),
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
        ("true && true", true),
        ("false || false", false),
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
    
    func testNameExpressionReportsUndefined() {
        let text = """
            [x] * 10
        """
        
        let diagnostics = """
            Variable 'x' doesn't exist
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testNameExpressionReportsNoErrorForInsertedToken() {
        let text = """
            []
        """
        
        let diagnostics = """
            Unexpected token <endOfFileToken>, expected <identifierToken>
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testAssignmentExpressionReportsUndefined() {
        let text = """
            [x] = 10
        """
        
        let diagnostics = """
            Variable 'x' doesn't exist
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testAssignmentExpressionReportsCannotAssign() {
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
    
    func testAssignmentExpressionReportsCannotConvert() {
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
    
    func testBlockStatementNoInfiniteLoop() {
        let text = """
            {
            [)][]
        """
        
        let diagnostics = """
            Unexpected token <closeParenthesisToken>, expected <identifierToken>
            Unexpected token <endOfFileToken>, expected <closeBraceToken>
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testIfStatementReportsCannotConvert() {
        let text = """
            {
                var x = 0
                if [10]
                    x = 10
            }
        """
        
        let diagnostics = """
            Cannot convert type 'Int' to 'Bool'
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testWhileStatementReportsCannotConvert() {
        let text = """
            {
                var x = 0
                if [10]
                    x = 10
            }
        """
        
        let diagnostics = """
            Cannot convert type 'Int' to 'Bool'
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testForStatementReportsCannotConvertLowerBound() {
        let text = """
            {
                var result = 0
                for i = [false] to 10
                    result = result + i
            }
        """
        
        let diagnostics = """
            Cannot convert type 'Bool' to 'Int'
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testForStatementReportsCannotConvertUpperBound() {
        let text = """
            {
                var result = 0
                for i = 1 to [true]
                    result = result + i
            }
        """
        
        let diagnostics = """
            Cannot convert type 'Bool' to 'Int'
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testUnaryExpressionReportsUdefined() {
        let text = """
            [+]true
        """
        
        let diagnostics = """
            Unary operator '+' is not defined for type 'Bool'
        """
        
        try! assertHasDiagnostics(text, diagnostics)
    }
    
    func testBinaryExpressionReportsUdefined() {
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
