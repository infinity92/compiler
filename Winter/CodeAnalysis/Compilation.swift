//
//  Compilation.swift
//  compiler
//
//  Created by Александр Котляров on 31.10.2021.
//

import Foundation

public var variables: [VariableSymbol: Any] = [:]

public class Compilation {
    public convenience init(syntax: SyntaxTree) {
        //self.syntax = syntax
        self.init(previous: nil, syntax: syntax)
    }
    
    private init(previous: Compilation?, syntax: SyntaxTree) {
        self.previous = previous
        self.syntax = syntax
    }
    
    public let previous: Compilation?
    let syntax: SyntaxTree
    private var _globalScope: BoundGlobalScope?
    var globalScope: BoundGlobalScope {
        if _globalScope == nil {
            _globalScope = Binder.bindGlobalScope(previous: previous?.globalScope, syntax: syntax.root)
        }
        
        return _globalScope!
    }
    
    public func continueWith(syntaxTree: SyntaxTree) -> Compilation {
        return Compilation(previous: self, syntax: syntaxTree)
    }
    
    public func evaluate() -> EvaluationResult {
        let diagnostics = syntax.diagnostics + globalScope.diagnostics
        if !diagnostics.isEmpty {
            return EvaluationResult(diagnostics: diagnostics, value: nil)
        }
        let evaluator = Evaluator(root: globalScope.expression)
        let value = evaluator.evaluate()
        
        return EvaluationResult(diagnostics: DiagnosticBag(), value: value)
    }
}




