//
//  Diagnostic.swift
//  compiler
//
//  Created by Александр Котляров on 31.10.2021.
//

import Foundation

struct Diagnostic: CustomStringConvertible {
    let span: TextSpan
    let message: String
    
    func toString() -> String {
        message
    }
    var description: String {
        message
    }
}


