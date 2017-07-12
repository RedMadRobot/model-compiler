//
//  Method.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 14.06.28.
//  Copyright © 28 Heisei RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Class method.
 */
public class Method: Equatable, CustomDebugStringConvertible {

    /**
     Method name.
     
     Doesn't include round brackets and argument names.
     */
    public let name: String
    
    /**
     Method arguments.
     */
    public let arguments: [Argument]
    
    /**
     Method annotations.
     
     Method annotations are located inside block comment above the method declaration.
     */
    public let annotations: [Annotation]
    
    /**
     Return type.
     */
    public let returnType: Typê?
    
    /**
     Method declaration line.
     */
    public let declaration: SourceCodeLine
    
    /**
     Method body.
     */
    public let body: [SourceCodeLine]

    /**
     Initializer.
     
     - parameter name: method name; see `Method.name`
     - parameter arguments: method arguments;
     - parameter annotaions: method annotations;
     - parameter returnType: return type;
     - parameter declaration: method declaration line;
     - parameter body: method body.
     */
    public init(
        name: String,
        arguments: [Argument],
        annotations: [Annotation],
        returnType: Typê?,
        declaration: SourceCodeLine,
        body: [SourceCodeLine]
    ) {
        self.name = name
        self.arguments = arguments
        self.annotations = annotations
        self.returnType = returnType
        self.declaration = declaration
        self.body = body
    }

    public var debugDescription: String {
        get {
            return "Method: name: \(self.name); return type: \(String(describing: self.returnType)); annotations: \(self.annotations)"
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
        }
    }

}

public func ==(left: Method, right: Method) -> Bool {
    return
        left.declaration == right.declaration
     && left.annotations == right.annotations
     && left.arguments   == right.arguments
     && left.name        == right.name
     && left.returnType  == right.returnType
     && left.body        == right.body
}

extension Sequence where Iterator.Element == Method {
    
    subscript(methodName: String) -> Iterator.Element? {
        for item in self {
            if item.name == methodName {
                return item
            }
        }
        return nil
    }
    
    func contains(methodName: String) -> Bool {
        return nil != self[methodName]
    }
    
}
