//
//  BoundScope.swift
//  Winter
//
//  Created by Александр Котляров on 15.11.2021.
//

import Foundation

class BoundScope {
    private var variables: [String: VariableSymbol] = [:]
    public var parent: BoundScope?
    
    public init(parent: BoundScope?) {
        self.parent = parent
    }
    
    public func tryDeclare(variable: VariableSymbol) -> Bool {
        if variables.keys.contains(variable.name) {
            return false
        }
        variables[variable.name] = variable
        return true
    }
    
    public func tryLookup(name: String, variable: inout VariableSymbol?) -> Bool {
        if let value = variables[name] {
            variable = value
            return true
        }
        
        guard let p = parent else {
            return false
        }
        
        return p.tryLookup(name: name, variable: &variable)
    }
    
    public func getDeclaredVariables() -> [VariableSymbol] {
        return variables.map { $1 }
    }
}
