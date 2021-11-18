//
//  BoundBinaryOperatorKind.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

enum BoundBinaryOperatorKind {
    case addition
    case substruction
    case multiplication
    case division
    
    case logicalAnd
    case logicalOr
    case equals
    case notEquals
    case less
    case lessOrEquals
    case greater
    case greaterOrEquals
}
