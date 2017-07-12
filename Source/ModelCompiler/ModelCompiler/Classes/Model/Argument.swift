//
//  Argument.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 14.06.28.
//  Copyright © 28 Heisei RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Method argument.
 */
public class Argument: Equatable, CustomDebugStringConvertible {
    
    /**
     Argument "external" name used on method calls.
     */
    public let name: String
    
    /**
     Argument "internal" name used inside method body.
     */
    public let bodyName: String
    
    /**
     Argument type.
     */
    public let type: Typê
    
    /**
     Argument annotations; N.B.: arguments only have inline annotations.
     */
    public let annotations: [Annotation]
    
    /**
     Argument declaration.
     
     Comes without prefix whitespace.
     */
    public let declaration: SourceCodeLine
    
    /**
     Initializer.
     
     - parameter name: argument "external" name used on method calls;
     - parameter bodyName: argument "internal" name used inside method body;
     - parameter type: argument type;
     - parameter annotations: list of argument annotations;
     - parameter declaration: argument declaration line without prefix and sufix whitespace.
     */
    public init(
        name: String,
        bodyName: String,
        type: Typê,
        annotations: [Annotation],
        declaration: SourceCodeLine
    ) {
        self.name        = name
        self.bodyName    = bodyName
        self.type        = type
        self.annotations = annotations
        self.declaration = declaration
    }

    public var debugDescription: String {
        get {
            return "Argument: name: \(self.name); body name: \(self.bodyName); type: \(self.type); annotations: \(self.annotations)"
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
        }
    }

}

public func ==(left: Argument, right: Argument) -> Bool {
    return
        left.annotations == right.annotations
     && left.declaration == right.declaration
     && left.type        == right.type
     && left.name        == right.name
     && left.bodyName    == right.bodyName
}

extension Sequence where Iterator.Element == Argument {
    
    subscript(argumentName: String) -> Iterator.Element? {
        for item in self {
            if item.name == argumentName {
                return item
            }
        }
        return nil
    }
    
    func contains(argumentName: String) -> Bool {
        return nil != self[argumentName]
    }
    
}
