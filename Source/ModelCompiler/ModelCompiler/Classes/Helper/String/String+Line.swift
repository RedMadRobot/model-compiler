//
//  String+Line.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 30.03.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation


public extension String {
    
    /**
     Add empty line.
     
     - returns: String appended with empty line.
     */
    public func addBlankLine() -> String {
        return addLine("")
    }
    
    /**
     Add **line** (with \n at the end).
     
     - parameter line: string to add.
     
     - returns: String appended with **line** (with \n at the end).
     */
    public func addLine(_ line: String) -> String {
        let straightLine: String = line.replacingOccurrences(of: "\n", with: "")
        
        return self + straightLine + "\n"
    }
    
    /**
     Convenient wrapper for + operator.
     */
    public func append(_ line: String) -> String {
        return self + line
    }
    
    /**
     Divide string into separate lines by \n
     */
    public func lines() -> [String] {
        return self.components(separatedBy: "\n")
    }
    
    /**
     Indent all lines with ```tabCount``` number of tabs (tab is four spaces).
     */
    public func indent(tabCount: Int = 1) -> String {
        var tab: String = ""
        for _ in 0..<tabCount {
            tab += "    "
        }
        return indent(prefix: tab)
    }
    
    /**
     Indent all lines with ```prefix```.
     */
    public func indent(prefix: String) -> String {
        return
            lines()
            .map { (line: String) -> String in
                if line.isEmpty {
                    return line
                }
                return prefix + line
            }
            .joined(separator: "\n")
    }
    
}
