//
//  SourceText.swift
//  Winter
//
//  Created by Александр Котляров on 15.11.2021.
//

import Foundation

public struct SourceText {
    
    public subscript(_ index: Int) -> Character {
        return text.char(at: index)
    }
    
    public var lines: [TextLine] = []
    let text: String
    
    public var count: Int {
        text.count
    }
    
    private init(_ text: String) {
        self.text = text
        lines = parseLines(sourceText: self, text: text)
    }
    
    static func from(text: String) -> SourceText {
        return SourceText(text)
    }
    
    private static func getLineBreakWidth(_ text: String, _ position: Int) -> Int {
        let char = text.char(at: position)
        let l = position + 1 >= text.count ? "\0" : text.char(at: position + 1)
        if char == "\r" && l == "\n" {
            return 2
        }
        if char == "\r" || char == "\n" {
            return 1
        }
        
        return 0
    }
    
    private static func addLine(_ result: inout [TextLine], _ sourceText: SourceText, _ position: Int, _ lineStart: Int, _ lineBreakWidth: Int) {
        let lineLength = position - lineStart
        let lineLengthIncludingBreak = lineLength + lineBreakWidth
        let line = TextLine(text: sourceText, start: lineStart, length: lineLength, lengthIncludingLineBreak: lineLengthIncludingBreak)
        result.append(line)
    }
    
    private func parseLines(sourceText: SourceText, text: String) -> [TextLine] {
        var result = [TextLine]()
        var lineStart = 0
        var position = 0
        while position < text.count {
            let lineBreakWidth = SourceText.getLineBreakWidth(text, position)
            if lineBreakWidth == 0 {
                position += 1
            } else {
                SourceText.addLine(&result, sourceText, position, lineStart, lineBreakWidth)
                position += lineBreakWidth
                lineStart = position
            }
            
            if position >= lineStart {
                SourceText.addLine(&result, sourceText, position, lineStart, 0)
            }
            
        }
        
        return result
    }
    
    public func getLineIndex(by position: Int) -> Int {
        var lower = 0
        var upper = lines.count - 1
        while lower <= upper {
            let index = lower + (upper - lower) / 2
            let start = lines[index].start
            if position == start {
                return index
            }
            if start > position {
                upper = index - 1
            } else {
                lower = index + 1
            }
        }
        
        return lower - 1
    }
    
    public func char(at index: Int) -> Character {
        return text.char(at: index)
    }
    
    public func toString () -> String {
        return text
    }
    
    public func toString(_ start: Int, offset length: Int) -> String {
        return text.substring(start, offset: length)
    }
    
    public func toString(_ span: TextSpan) -> String {
        return text.substring(span.start, offset: span.length)
    }
}


