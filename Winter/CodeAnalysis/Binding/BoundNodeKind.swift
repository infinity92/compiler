//
//  BoundNodeKind.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

enum BoundNodeKind {
    // MARK: - Expressions
    case unaryExpression
    case literalExpression
    case binaryExpression
    case variableExpression
    case assignmentExpression
    
    //MARK: - Statements
    case blockStatement
    case expressionStatement
    case variableDeclatation
}
