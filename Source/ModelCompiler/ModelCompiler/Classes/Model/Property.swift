//
//  Property.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 30.03.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Class property.
 */
public class Property: Equatable, CustomDebugStringConvertible {
    
    /**
     Property name.
     */
    public let name: String
    
    /**
     Property type.
     */
    public let type: Typê
    
    /**
     Property annotations.
     
     Property annotations are parsed from both block comment above property declaration and inline
     comment.
     */
    public let annotations: [Annotation]
    
    /**
     Property is `let`.
     
     Otherwise `var`.
     */
    public let constant: Bool
    
    /**
     Property declaration line.
     */
    public let declaration: SourceCodeLine
    
    /**
     Initializer.
     
     - parameter name: property name;
     - parameter type: property type;
     - parameter annotations: property annotations;
     - parameter constant: property is `let`;
     - parameter declaration: property declaration line.
     */
    public init(
        name: String,
        type: Typê,
        annotations: [Annotation],
        constant: Bool,
        declaration: SourceCodeLine
    ) {
        self.name        = name
        self.type        = type
        self.annotations = annotations
        self.constant    = constant
        self.declaration = declaration
    }
    
    public var debugDescription: String {
        get {
            return "Property: name: \(self.name); type: \(self.type); constant: \(self.constant); annotations: \(self.annotations)"
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
        }
    }
    
}

public func ==(left: Property, right: Property) -> Bool {
    return left.name        == right.name
        && left.type        == right.type
        && left.annotations == right.annotations
        && left.constant    == right.constant
        && left.declaration == right.declaration
}

extension Sequence where Iterator.Element == Property {
    
    subscript(propertyName: String) -> Iterator.Element? {
        for item in self {
            if item.name == propertyName {
                return item
            }
        }
        return nil
    }
    
    func contains(propertyName: String) -> Bool {
        return nil != self[propertyName]
    }
    
}
