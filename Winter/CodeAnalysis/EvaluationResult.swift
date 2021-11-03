//
//  EvaluationResult.swift
//  compiler
//
//  Created by Александр Котляров on 31.10.2021.
//

import Foundation

struct EvaluationResult {
    let diagnostics: DiagnosticBag
    let value: Any?
}
