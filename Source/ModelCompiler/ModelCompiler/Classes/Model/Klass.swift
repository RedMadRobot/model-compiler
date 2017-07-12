//
//  Klass.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 30.03.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Class model.
 
 Used for classes, protocols and structures.
 */
public class Klass: Equatable, CustomDebugStringConvertible {
    
    /**
     Model type.
     
     `klass` for classes, `protokol` for protocols and `strukt` for structures.
     */
    public enum KlassType: CustomDebugStringConvertible {
        case klass
        case protokol
        case strukt
        
        public var debugDescription: String {
            get {
                switch self {
                    case .klass:    return "Klass"
                    case .protokol: return "Protokol"
                    case .strukt:   return "Strukt"
                }
            }
        }
    }
    
    /**
     Model type; class, protocol or structure.
     */
    public let type: KlassType
    
    /**
     Name of the class.
     */
    public let name: String
    
    /**
     Parent name and conformed protocols.
     */
    public let parents: [String]
    
    /**
     List of class properties.
     */
    public let properties: [Property]
    
    /**
     Class annotations.
     
     Class anotations are located inside block comment above class declaration.
     */
    public let annotations: [Annotation]
    
    /**
     Class declaration line.
     */
    public let declaration: SourceCodeLine
    
    /**
     Class methods.
     */
    public let methods: [Method]
    
    /**
     Class body.
     */
    public let body: [SourceCodeLine]
    
    /**
     Initializer.
     */
    public init(
        type:           KlassType,
        name:           String,
        parents:        [String],
        properties:     [Property],
        annotations:    [Annotation],
        declaration:    SourceCodeLine,
        methods:        [Method],
        body:           [SourceCodeLine]
    ) {
        self.type        = type
        self.name        = name
        self.parents     = parents
        self.properties  = properties
        self.annotations = annotations
        self.declaration = declaration
        self.methods     = methods
        self.body        = body
    }
    
    public var debugDescription: String {
        get {
            return "\(self.type): name: \(self.name); parents: \(self.parents.joined(separator: ", ")); annotations: \(self.annotations)"
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
        }
    }
    
}

public func ==(left: Klass, right: Klass) -> Bool {
    return left.type        == right.type
        && left.name        == right.name
        && left.parents     == right.parents
        && left.properties  == right.properties
        && left.annotations == right.annotations
        && left.declaration == right.declaration
        && left.methods     == right.methods
}

extension Sequence where Iterator.Element == Klass {
    
    subscript(klassName: String) -> Iterator.Element? {
        for item in self {
            if item.name == klassName {
                return item
            }
        }
        return nil
    }
    
    func contains(klassName: String) -> Bool {
        return nil != self[klassName]
    }
    
}
