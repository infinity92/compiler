//
//  VariableSymbol.swift.swift
//  compiler
//
//  Created by Александр Котляров on 02.11.2021.
//

import Foundation

public struct VariableSymbol {
    public let name: String
    public let isReadOnly: Bool
    public let varType: Any
}

extension VariableSymbol: Hashable {
    public static func == (lhs: VariableSymbol, rhs: VariableSymbol) -> Bool {
        lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
