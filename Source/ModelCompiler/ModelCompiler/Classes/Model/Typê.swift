//
//  Typê.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 30.03.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Type of class properties, methods, method arguments, variables etc.
 
 N.B.: Enumerations are not supported yet.
 */
public indirect enum Typê: Equatable, CustomStringConvertible {
    
    /**
     Boolean.
     */
    case BoolType
    
    /**
     Anything, which contains "Int" in it: Int, Int16, Int32, Int64, UInt etc.
     */
    case IntType
    
    /**
     Float.
     */
    case FloatType
    
    /**
     Double.
     */
    case DoubleType
    
    /**
     String
     */
    case StringType
    
    /**
     Date (formerly known as NSDate).
     */
    case DateType
    
    /**
     Data (formerly known as NSData).
     */
    case DataType
    
    /**
     Anything optional; wraps actual type.
     */
    case OptionalType(wrapped: Typê)
    
    /**
     Non-primitive type. Except for Date and collections of any kind.
     */
    case ObjectType(name: String)
    
    /**
     Array collection.
     */
    case ArrayType(item: Typê)
    
    /**
     Map/dictionary collection.
     */
    case MapType(pair: (key: Typê, value: Typê))
    
    /**
     Generic type.
     
     Like `ObjectType`, contains type name and also contains type for item in corner brakets.
     */
    case GenericType(name: String, item: Typê)
    
    /**
     Defines, whether the type is primitive.
     
     Primitive types include optional and non-optional bools, ints, floats, doubles and strings.
     */
    public func isPrimitive() -> Bool {
        switch self {
            case .BoolType, .IntType, .FloatType, .DoubleType, .StringType: return true
            case .DateType, .DataType, .ObjectType, .ArrayType, .MapType, .GenericType: return false
            case .OptionalType(let wrapped): return wrapped.isPrimitive()
        }
    }
    
    public var description: String {
        get {
            switch self {
            case .BoolType: return "Bool"
            case .IntType: return "Int"
            case .FloatType: return "Float"
            case .DoubleType: return "Double"
            case .StringType: return "String"
            case .DateType: return "Date"
            case .DataType: return "Data"
            case let .OptionalType(wrapped): return "\(wrapped)?"
            case let .ObjectType(name): return "\(name)"
            case let .ArrayType(item): return "[\(item)]"
            case let .MapType(keyValue): return "[\(keyValue.key) : \(keyValue.value)]"
            case let .GenericType(name, item): return "\(name)<\(item)>"
            }
        }
    }
}

public func ==(left: Typê, right: Typê) -> Bool {
    switch (left, right) {
        case (Typê.BoolType, Typê.BoolType):
            return true
        
        case (Typê.IntType, Typê.IntType):
            return true
        
        case (Typê.FloatType, Typê.FloatType):
            return true
        
        case (Typê.DoubleType, Typê.DoubleType):
            return true
        
        case (Typê.DateType, Typê.DateType):
            return true
        
        case (Typê.DataType, Typê.DataType):
            return true
        
        case (Typê.StringType, Typê.StringType):
            return true
        
        case (let Typê.OptionalType(wrappedLeft), let Typê.OptionalType(wrappedRight)):
            return wrappedLeft == wrappedRight
        
        case (let Typê.ObjectType(name: leftName), let Typê.ObjectType(name: rightName)):
            return leftName == rightName
        
        case (let Typê.ArrayType(item: leftItem), let Typê.ArrayType(item: rightItem)):
            return leftItem == rightItem
        
        case (let Typê.MapType(pair: (key: leftKey, value: leftValue)), let Typê.MapType(pair: (key: rightKey, value: rightValue))):
            return leftKey == rightKey && leftValue == rightValue
        
        case (let Typê.GenericType(leftName, leftItem), let Typê.GenericType(rightName, rightItem)):
            return leftName == rightName && leftItem == rightItem
        
        default:
            return false
    }
}
