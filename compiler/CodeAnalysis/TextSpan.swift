//
//  TextSpan.swift
//  compiler
//
//  Created by Александр Котляров on 31.10.2021.
//

import Foundation

struct TextSpan {
    let start: Int
    let length: Int
    var end: Int {
        start + length
    }
}
