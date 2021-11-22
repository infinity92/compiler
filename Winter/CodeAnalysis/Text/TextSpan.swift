//
//  TextSpan.swift
//  compiler
//
//  Created by Александр Котляров on 31.10.2021.
//

import Foundation

public struct TextSpan: Equatable {
    public let start: Int
    public let length: Int
    public var end: Int {
        start + length
    }
    
    public static func fromBounds(_ start: Int, _ end: Int) -> TextSpan {
        let length = end - start
        
        return TextSpan(start: start, length: length)
    }
}
