//
//  Compilation.swift
//  compiler
//
//  Created by Александр Котляров on 31.10.2021.
//

import Foundation

class Compilation {
    init(syntax: SyntaxTree) {
        self.syntax = syntax
    }
    
    let syntax: SyntaxTree
    
    func evaluate() -> EvaluationResult {
        let binder = Binder()
        let boundExpression = try! binder.bindExpression(syntax: syntax.root)
        let diagnostics = syntax.diagnostics + binder.diagnostics
        if !diagnostics.isEmpty {
            return EvaluationResult(diagnostics: diagnostics, value: nil)
        }
        let evaluator = Evaluator(root: boundExpression)
        let value = evaluator.evaluate()
        
        return EvaluationResult(diagnostics: DiagnosticBag(), value: value)
    }
}




