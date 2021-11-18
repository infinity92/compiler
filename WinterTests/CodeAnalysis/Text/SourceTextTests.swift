//
//  SourceTextTests.swift
//  WinterTests
//
//  Created by Александр Котляров on 15.11.2021.
//

import XCTest
@testable import Winter

class SourceTextTests: XCTestCase {
    
    private let data = [
        (".", 1),
        (".\r\n", 2),
        (".\r\n\r\n", 3),
    ]

    func testIcludedLastLine() {
        data.forEach { (text, expectedLineCount) in
            let sourceText = SourceText.from(text: text)
            XCTAssertEqual(expectedLineCount, sourceText.lines.count)
        }
    }

}
