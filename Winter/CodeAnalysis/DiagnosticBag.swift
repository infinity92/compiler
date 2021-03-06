//
//  DiagnosticBag.swift
//  compiler
//
//  Created by Александр Котляров on 31.10.2021.
//

import Foundation

public struct DiagnosticBag: Sequence, IteratorProtocol {
    private var diagnostics: [Diagnostic] = []
    private var index = 0
    public var isEmpty: Bool {
        diagnostics.isEmpty
    }
    
    private mutating func report(span: TextSpan, message: String) {
        let diagnostic = Diagnostic(span: span, message: message)
        self.diagnostics.append(diagnostic)
    }
    
    public mutating func next() -> Diagnostic? {
        if diagnostics.count == 0 {
                return nil
        } else {
            defer { index += 1 }
            return diagnostics.count > index ? self.diagnostics[index] : nil
        }
    }
    
    public subscript(index: Int) -> Diagnostic {
        return diagnostics[index]
    }
    
    public func toArray() -> [Diagnostic] {
        return diagnostics
    }
    
    mutating func reportInvalidNumber(_ span: TextSpan, _ text: String, _ type: Any) {
        report(span: span, message: "The number \(text) isn't valid \(type)")
    }
    
    mutating func reportBadCharacter(_ position: Int, _ current: Character) {
        let span = TextSpan(start: position, length: 1)
        report(span: span, message: "ERROR: bad character input: \(current)")
    }
    
    mutating func addRange(_ diagnostics: DiagnosticBag) {
        self.diagnostics.append(contentsOf: diagnostics.diagnostics)
    }
    
    mutating func reportUnexpectedToken(_ span: TextSpan, _ actualKind: SyntaxKind, _ expectedKind: SyntaxKind) {
        report(span: span, message: "Unexpected token <\(actualKind)>, expected <\(expectedKind)>")
    }
    
    mutating func reportUndefinedUnaryOperator(_ span: TextSpan, _ operatorText: String, _ operandType: Any) {
        let message = "Unary operator '\(operatorText)' is not defined for type '\(operandType)'"
        report(span: span, message: message)
    }
    
    mutating func reportUndefinedBinaryOperator(_ span: TextSpan, _ operatorText: String, _ boundLeftType: Any, _ boundRightType: Any) {
        let message = "Binary operator '\(operatorText)' is not defined for type '\(boundLeftType)' and '\(boundRightType)'"
        report(span: span, message: message)
    }
    
    mutating func reportUndefinedName(_ span: TextSpan, _ name: String) {
        report(span: span, message: "Variable '\(name)' doesn't exist")
    }
    
    mutating func reportCannotConvert(_ span: TextSpan, _ fromeType: Any, _ toType: Any) {
        report(span: span, message: "Cannot convert type '\(fromeType)' to '\(toType)'")
    }
    
    mutating func reportVariableAlreadyDeclared(_ span: TextSpan, _ name: String) {
        report(span: span, message: "Variable '\(name)' is already declared")
    }
    
    mutating func reportCannotAssign(_ span: TextSpan, _ name: String) {
        report(span: span, message: "Variable '\(name)' is read-only and cannot be assigned to")
    }
    
    static func + (lhs: DiagnosticBag, rhs: DiagnosticBag) -> DiagnosticBag  {
        //TODO: add init(array<Diagnostic>)
        var bag = DiagnosticBag()
        bag.addRange(lhs)
        bag.addRange(rhs)
        return bag
    }
}
