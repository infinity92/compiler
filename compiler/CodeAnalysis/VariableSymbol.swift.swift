//
//  VariableSymbol.swift.swift
//  compiler
//
//  Created by Александр Котляров on 02.11.2021.
//

import Foundation

struct VariableSymbol {
    let name: String
    let varType: Any
}

extension VariableSymbol: Hashable {
    static func == (lhs: VariableSymbol, rhs: VariableSymbol) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
