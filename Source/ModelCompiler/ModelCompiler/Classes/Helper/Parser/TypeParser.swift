//
//  TypeParser.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 04.04.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation

/**
 An entity that extracts type from source code line.
 
 Use cases:
 - extract type of local variable;
 - extract type of class/struct property;
 - extract type of method parameter;
 - extract type of tuple parameter (TODO)
 */
open class TypeParser {
    
    /**
     Parse type from local variable declaration.
     
     ```var variable: String = "abc"```
     */
    public func parse(rawVariableLine line: SourceCodeLine) throws -> Typê {
        // remove comments, leave actual source code:
        let sourceCode: String = line.line.truncateFromWord("//")
        
        // check if initial value is provided and guess its type:
        if sourceCode.contains("=") {
            let assignedValue: String = sourceCode.truncateAllBeforeWord("=", deleteWord: true).trimmingCharacters(in: CharacterSet.whitespaces)
            return try self.guessType(ofVariableValue: assignedValue, declaration: line)
        }
        
        // cut everything before semicolon, leave only type:
        if sourceCode.contains(":") {
            let rawVariableType: String = sourceCode.truncateAllBeforeWord(":", deleteWord: true).trimmingCharacters(in: CharacterSet.whitespaces)
            return try self.parse(rawType: rawVariableType, declaration: line)
        }
        
        throw self.generateTypeParserException(forSourceCodeLine: line)
    }
    
    /**
     Parse type from method or function parameter declaration.
     
     ```method(externalParameterName parameterName: String = "abc", // comment```
     */
    public func parse(rawMethodParameterLine line: SourceCodeLine) throws -> Typê {
        let lineStr: String = line.line
                                    .truncateFromWord("//")
                                    .replacingOccurrences(of: ",", with: "")
                                    .trimmingCharacters(in: CharacterSet.whitespaces)
                                    .truncateAllBeforeWord("(", deleteWord: true)
        return try parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: line.absoluteFilePath,
                lineNumber: line.lineNumber,
                line: lineStr
            )
        )
    }
    
    /**
     Parse type from class property declaration.
     
     ```public lazy var variable: String = { ...```
     */
    public func parse(rawPropertyLine line: SourceCodeLine) throws -> Typê {
        // lazy and computed properties are not supported yet
        if line.line.contains("lazy") {
            print(
                CompilerMessage(
                    line: line,
                    message: "[Compiler] Lazy and computed properties are not properly supported yet",
                    type: CompilerMessage.MessageType.Warning
                )
            )
        }
        
        // cut getters and setters
        let lineWithoutBrackets: String = line.line.truncateFromWord("{")
        
        // cut access control statement like "open", "public" etc
        // also cut memory management flags like "weak"
        // turn property into regular variable
        let lineIgnoringAccessControlAndMemoryManagement: String
        if line.line.contains("let ") {
            lineIgnoringAccessControlAndMemoryManagement = lineWithoutBrackets.truncateAllBeforeWord("let ")
        } else {
            lineIgnoringAccessControlAndMemoryManagement = lineWithoutBrackets.truncateAllBeforeWord("var ")
        }
        
        return try self.parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: line.absoluteFilePath,
                lineNumber: line.lineNumber,
                line: lineIgnoringAccessControlAndMemoryManagement
            )
        )
    }
    
    /**
     Parse raw type line without any other garbage.
     
     ```MyType<[Entity]>```
     */
    public func parse(rawType: String, declaration: SourceCodeLine) throws -> Typê {
        // check type ends with ?
        if rawType.hasSuffix("?") {
            return Typê.OptionalType(
                wrapped: try parse(rawType: String(rawType.characters.dropLast()), declaration: declaration)
            )
        }
        
        if rawType.contains("<") && rawType.contains(">") {
            let name: String = rawType.truncateFromWord("<").truncateLeadingWhitespace()
            let itemName: String = rawType.truncateAllBeforeWord("<", deleteWord: true).truncateFromWord(">")
            let itemType: Typê = try self.parse(rawType: itemName, declaration: declaration)
            return Typê.GenericType(name: name, item: itemType)
        }
        
        if rawType.contains("[") && rawType.contains("]") {
            let collecitonItemTypeName: String = rawType.truncateAllBeforeWord("[", deleteWord: true).truncateFromWord("]").trimmingCharacters(in: CharacterSet.whitespaces)
            return try self.parseCollectionItemType(collecitonItemTypeName, line: declaration)
        }
        
        if rawType == "Bool" {
            return Typê.BoolType
        }
        
        if rawType.contains("Int") {
            return Typê.IntType
        }
        
        if rawType == "Float" {
            return Typê.FloatType
        }
        
        if rawType == "Double" {
            return Typê.DoubleType
        }
        
        if rawType == "Date" {
            return Typê.DateType
        }
        
        if rawType == "Data" {
            return Typê.DataType
        }
        
        if rawType == "String" {
            return Typê.StringType
        }
        
        var objectTypeName: String = rawType.firstWord()
        if objectTypeName.characters.last == "?" {
            objectTypeName = String(objectTypeName.characters.dropLast())
        }
        
        if objectTypeName.isEmpty {
            throw self.generateTypeParserException(forSourceCodeLine: declaration)
        }
        
        return Typê.ObjectType(name: objectTypeName)
    }
    
}
    
private extension TypeParser {
    
    func guessType(ofVariableValue value: String, declaration: SourceCodeLine) throws -> Typê {
        // collections are not supported yet
        if value.contains("[") {
            throw self.generateTypeParserException(
                forSourceCodeLine: declaration,
                message: "[Compiler] Could not determine value type; collections are not supported"
            )
        }
        
        // check value is text in quotes:
        // let abc = "abcd"
        if let _ = value.range(of: "^\"(.*)\"$", options: .regularExpression) {
            return .StringType
        }
        
        // check value is double:
        // let abc = 123.45
        if let _ = value.range(of: "^(\\d+)\\.(\\d+)$", options: .regularExpression) {
            return .DoubleType
        }
        
        // check value is int:
        // let abc = 123
        if let _ = value.range(of: "^(\\d+)$", options: .regularExpression) {
            return .IntType
        }
        
        // check value is bool
        // let abc = true
        if value.contains("true") || value.contains("false") {
            return .BoolType
        }
        
        // check value contains object init statement:
        // let abc = Object(some: 123)
        if let _ = value.range(of: "^(\\w+)\\((.*)\\)$", options: .regularExpression) {
            let rawValueTypeName: String = value.truncateFromWord("(")
            return try parse(rawType: rawValueTypeName, declaration: declaration)
        }

        throw self.generateTypeParserException(forSourceCodeLine: declaration)
    }
    
    func parseCollectionItemType(_ collecitonItemTypeName: String, line: SourceCodeLine) throws -> Typê {
        if collecitonItemTypeName.contains(":") {
            let keyTypeName:   String = collecitonItemTypeName.truncateFromWord(":")
            let valueTypeName: String = collecitonItemTypeName.truncateAllBeforeWord(":", deleteWord: true)
            
            return Typê.MapType(pair: (key: try self.parse(rawType: keyTypeName, declaration: line), value: try self.parse(rawType: valueTypeName, declaration: line)))
        } else {
            return Typê.ArrayType(item: try self.parse(rawType: collecitonItemTypeName, declaration: line))
        }
    }
    
    func generateTypeParserException(
        forSourceCodeLine line: SourceCodeLine,
        message: String = "[Compiler] Could not determine type"
    ) -> CompilerMessage {
        return CompilerMessage(
            line: line,
            message: message
        )
    }
    
}
