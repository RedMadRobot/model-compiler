//
//  SourceCodeLine.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 14.06.28.
//  Copyright © 28 Heisei RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Line of the `SourceCodeFile`. Represents a line of the source code with meta-information helping to
 compose errors and warnings in case they occur.
 
 - seealso: `SourceCodeFile`.
 */
public class SourceCodeLine: CustomDebugStringConvertible, Equatable {
    
    /**
     Absolute path to file, where source code line is contained.
     */
    public let absoluteFilePath: String
    
    /**
     Line number.
     */
    public let lineNumber: Int
    
    /**
     Line itself.
     */
    public let line: String
    
    /**
     Initializer.
     */
    public init(absoluteFilePath: String, lineNumber: Int, line: String) {
        self.absoluteFilePath   = absoluteFilePath
        self.lineNumber         = lineNumber
        self.line               = line
    }
    
    public var debugDescription: String {
        get {
            return "Source Code Line: filename: \(self.absoluteFilePath); line number: \(self.lineNumber); line: \(self.line)"
        }
    }
}

public func ==(left: SourceCodeLine, right: SourceCodeLine) -> Bool {
    return
        left.lineNumber         == right.lineNumber
     && left.line               == right.line
     && left.absoluteFilePath   == right.absoluteFilePath
}
