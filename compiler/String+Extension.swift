//
//  String+Extension.swift
//  compiler
//
//  Created by Александр Котляров on 21.10.2021.
//

import Foundation

extension String {
    func substring(_ r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ..< end])
    }
    
    func substring(_ start: Int, offset: Int) -> String {
        let start = index(startIndex, offsetBy: start)
        let end = index(start, offsetBy: offset)
        return String(self[start ..< end])
    }
    
    func char(at index:Int) -> Character {
        let i = self.index(startIndex, offsetBy: index)
        return self[i]
    }
}
