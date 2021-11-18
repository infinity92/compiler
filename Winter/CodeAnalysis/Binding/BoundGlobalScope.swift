//
//  BoundGlobalScope.swift
//  Winter
//
//  Created by Александр Котляров on 16.11.2021.
//

import Foundation

class BoundGlobalScope {
    public let previous: BoundGlobalScope?
    public let diagnostics: DiagnosticBag
    public var variables: [VariableSymbol]
    public let statement: BoundStatement
    
    init(previous: BoundGlobalScope?, diagnostics: DiagnosticBag, variables: [VariableSymbol], statement: BoundStatement) {
        self.previous = previous
        self.diagnostics = diagnostics
        self.variables = variables
        self.statement = statement
    }
}
