//
//  TextSpan.swift
//  compiler
//
//  Created by Александр Котляров on 31.10.2021.
//

import Foundation

public struct TextSpan {
    public let start: Int
    public let length: Int
    public var end: Int {
        start + length
    }
}
