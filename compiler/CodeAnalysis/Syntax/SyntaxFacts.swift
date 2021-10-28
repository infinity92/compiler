//
//  SyntaxFacts.swift
//  compiler
//
//  Created by Александр Котляров on 28.10.2021.
//

import Foundation

class SyntaxFacts {
    static func getKeywordKind(text: String) -> SyntaxKind {
        switch (text) {
        case "true":
            return .trueKeyword
        case "false":
            return .falseKeyword
        default:
            return .identifierToken
        }
    }
}
