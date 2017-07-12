//
//  SourceCodeFile.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 14.06.28.
//  Copyright © 28 Heisei RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Representation of the source code file to be compiled.
 
 Contains meta-information, like absolute file path and line numbers, to make possible errors' and 
 warnings' generation.
 
 - seealso: `SourceCodeLine`
 */
public class SourceCodeFile: CustomDebugStringConvertible, Equatable {
    
    /**
     Absolute file path.
     */
    public let absoluteFilePath: String
    
    /**
     Source code lines.
     
     - seealso: `SourceCodeLine`
     */
    public let lines: [SourceCodeLine]
    
    /**
     Initializer.
     */
    public init(absoluteFilePath: String, lines: [SourceCodeLine]) {
        self.absoluteFilePath   = absoluteFilePath
        self.lines              = lines
    }
    
    /**
     Convenience initializer for cases, when contents of the source code file haven't been conveted
     to the `SourceCodeLine` instances yet.
     */
    convenience init(absoluteFilePath: String, contents: String) {
        var sourceCodeLines: [SourceCodeLine] = []
    
        for (index, line) in contents.lines().enumerated() {
            sourceCodeLines.append(
                SourceCodeLine(
                    absoluteFilePath: absoluteFilePath,
                    lineNumber: index + 1,
                    line: line
                )
            )
        }
    
        self.init(absoluteFilePath: absoluteFilePath, lines: sourceCodeLines)
    }
    
    public var debugDescription: String {
        get {
            return "SourceCodeFile: filename: \(self.absoluteFilePath); lines: \(self.lines)"
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
        }
    }
}

public func ==(left: SourceCodeFile, right: SourceCodeFile) -> Bool {
    return left.absoluteFilePath == right.absoluteFilePath
        && left.lines            == right.lines
}
