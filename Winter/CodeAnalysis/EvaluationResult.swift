//
//  EvaluationResult.swift
//  compiler
//
//  Created by Александр Котляров on 31.10.2021.
//

import Foundation

public struct EvaluationResult {
    public let diagnostics: DiagnosticBag
    public let value: Any?
}
