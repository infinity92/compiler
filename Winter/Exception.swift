//
//  Exception.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

public struct Exception: Error {
    public let message: String

    public init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
