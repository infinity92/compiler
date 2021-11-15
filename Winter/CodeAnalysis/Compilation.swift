//
//  Compilation.swift
//  compiler
//
//  Created by Александр Котляров on 31.10.2021.
//

import Foundation

public var variables: [VariableSymbol: Any] = [:]

public class Compilation {
    public init(syntax: SyntaxTree) {
        self.syntax = syntax
    }
    
    let syntax: SyntaxTree
    
    public func evaluate() -> EvaluationResult {
        let binder = Binder()
        let boundExpression = try! binder.bindExpression(syntax: syntax.root.expression)
        let diagnostics = syntax.diagnostics + binder.diagnostics
        if !diagnostics.isEmpty {
            return EvaluationResult(diagnostics: diagnostics, value: nil)
        }
        let evaluator = Evaluator(root: boundExpression)
        let value = evaluator.evaluate()
        
        return EvaluationResult(diagnostics: DiagnosticBag(), value: value)
    }
}




