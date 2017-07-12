//
//  Annotation.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 30.03.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Meta-information about classes, properties, methods and method arguments located in nearby 
 comments.
 */
public class Annotation: Equatable, CustomDebugStringConvertible {
    
    /**
     Name of the annotation; doesn't include "@" symbol.
     */
    public let name: String
    
    /**
     Value of the annotation; optional, contains first word after annotation name, if any.
     
     Inline annotations may be divided by semicolon, which may go immediately after annotation name
     in case annotation doesn't have any value.
     */
    public let value: String?
    
    /**
     Initializer.
     
     - parameter name: annotation name;
     - parameter value: optional annotation value.
     */
    public init(name: String, value: String?) {
        self.name  = name
        self.value = value
    }
    
    public var debugDescription: String {
        get {
            return "Annotation: name = \(self.name); value = \(String(describing: self.value))"
        }
    }
    
}

public func ==(left: Annotation, right: Annotation) -> Bool {
    return left.name  == right.name
        && left.value == right.value
}

extension Sequence where Iterator.Element == Annotation {
    
    subscript(annotationName: String) -> Iterator.Element? {
        for item in self {
            if item.name == annotationName {
                return item
            }
        }
        return nil
    }
    
    func contains(annotationName: String) -> Bool {
        return nil != self[annotationName]
    }
    
}
