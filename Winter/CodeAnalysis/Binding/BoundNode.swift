//
//  BoundNode.swift
//  compiler
//
//  Created by Александр Котляров on 27.10.2021.
//

import Foundation

protocol BoundNode {
    var kind: BoundNodeKind { get }
}
