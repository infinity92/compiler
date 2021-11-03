//
//  Diagnostic.swift
//  compiler
//
//  Created by Александр Котляров on 31.10.2021.
//

import Foundation

public struct Diagnostic: CustomStringConvertible {
    public let span: TextSpan
    let message: String
    
    func toString() -> String {
        message
    }
    public var description: String {
        message
    }
}


