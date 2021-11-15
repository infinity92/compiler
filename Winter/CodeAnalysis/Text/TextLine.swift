//
//  TextLine.swift
//  Winter
//
//  Created by Александр Котляров on 15.11.2021.
//

import Foundation

public struct TextLine {
    let text: SourceText
    public let start: Int
    let length: Int
    let lengthIncludingLineBreak: Int
    var span: TextSpan {
        TextSpan(start: start, length: length)
    }
    var spanIncludingLineBreak: TextSpan {
        TextSpan(start: start, length: lengthIncludingLineBreak)
    }
    public var end: Int { start + length }
    
    public func toString () -> String {
        return text.toString(span)
    }
}
