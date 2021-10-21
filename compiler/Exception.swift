//
//  Exception.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

struct Exception: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var localizedDescription: String {
        return message
    }
}
