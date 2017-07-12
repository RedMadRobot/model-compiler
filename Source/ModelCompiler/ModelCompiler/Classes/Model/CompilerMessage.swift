//
//  CompilerMessage.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 14.06.28.
//  Copyright © 28 Heisei RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Compiler error, warning or note.
 
 `CompilerMessage` instance is designed to be printed via `print()` method such that IDE will
 receieve output and display errors and warnings inside source code editor as actual errors and
 warnings.
 */
public class CompilerMessage: Error, CustomDebugStringConvertible, Equatable {

    /**
     Red errors, yellow warnings and "invisible" notes to be found in build log.
     */
    public enum MessageType: String {
        case Error = "error"
        case Warning = "warning"
        case Note = "note"
    }

    /**
     Absolute path to source code file.
     */
    public let absoluteFilePath: String
    
    /**
     Line number, where error/warning/note occured.
     */
    public let lineNumber: Int
    
    /**
     Message to be displayed.
     */
    public let message: String
    
    /**
     Error, warning or note.
     */
    public let type: MessageType

    /**
     Column, where error/warning/note occured. 
     
     Not supported.
     */
    private let columnNumber: Int
    
    /**
     Initializer.
     
     - parameter line: `SourceCodeLine` instance for line, where the message should be displayed;
     - parameter message: message to be displayed;
     - parameter type: error, warning or note.
     */
    public convenience init(
        line: SourceCodeLine,
        message: String,
        type: MessageType = .Error
    ) {
        self.init(
            absoluteFilePath: line.absoluteFilePath,
            lineNumber: line.lineNumber,
            message: message,
            type: type
        )
    }
    
    /**
     Initializer.
     
     - parameter absoluteFilePath: absolute path to source code file;
     - parameter lineNumber: line number, where error/warning/note occured;
     - parameter message: message to be displayed;
     - parameter type: error, warning or note.
     */
    public init(
        absoluteFilePath: String,
        lineNumber: Int,
        message: String,
        type: MessageType = .Error
    ) {
        self.absoluteFilePath   = absoluteFilePath
        self.lineNumber         = lineNumber
        self.message            = message
        self.type               = type

        self.columnNumber = 1
    }
    
    public var debugDescription: String {
        get {
            return "\(self.absoluteFilePath):\(self.lineNumber):\(self.columnNumber): \(self.type.rawValue): \(self.message)\n"
        }
    }
    
}

public func ==(left: CompilerMessage, right: CompilerMessage) -> Bool {
    return left.absoluteFilePath == right.absoluteFilePath
        || left.lineNumber       == right.lineNumber
        || left.message          == right.message
        || left.type             == right.type
}
