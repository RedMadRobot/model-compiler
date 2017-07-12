//
//  PropertyParser.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 30.03.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Finds properties in class body.
 */
open class PropertyParser: KlassContentParser<Property> {
    
    open override func detectContent(line: SourceCodeLine) -> Bool {
        let cleanLine: String = line.line.truncateFromWord("//")
        return nil != self.parsePropertyModifier(lineWithoutComments: cleanLine)
    }
    
    open override func appendContent(line: SourceCodeLine) {
        // nothing to do, only single-line properties are supported
    }
    
    open override func endedParsingContent(line: SourceCodeLine, documentation: [SourceCodeLine]) throws -> Property? {
        let cleanLine: String = line.line.truncateFromWord("//")
        
        let lastBlockComment: String = documentation.reduce("", { (comment: String, line: SourceCodeLine) -> String in
            return comment + line.line + "\n"
        })
        
        let propertyModifier: PropertyModifier = self.parsePropertyModifier(lineWithoutComments: cleanLine)!
        let name: String = try self.parsePropertyName(cleanLine: cleanLine, propertyModifier: propertyModifier, declaration: line)
        let type: Typê = try TypeParser().parse(rawPropertyLine: line)
        let annotations: [Annotation] = AnnotationParser().parse(comment: lastBlockComment)
        let isConstant: Bool = propertyModifier == PropertyModifier.Let
        
        let inlineAnnotations: [Annotation]
        if line.line.contains("//") {
            inlineAnnotations = AnnotationParser().parse(comment: line.line.truncateAllBeforeWord("//"))
        } else {
            inlineAnnotations = []
        }
        
        return Property(
            name: name,
            type: type,
            annotations: annotations + inlineAnnotations,
            constant: isConstant,
            declaration: line
        )
    }
    
    fileprivate enum PropertyModifier {
        case Let
        case Var
        func raw() -> String {
            switch self {
                case PropertyModifier.Let: return "let"
                case PropertyModifier.Var: return "var"
            }
        }
    }
    
}

private extension PropertyParser {
    
    func parsePropertyModifier(lineWithoutComments: String) -> PropertyModifier? {
        if lineWithoutComments.contains(" var ") || lineWithoutComments.hasPrefix("var ") {
            return PropertyModifier.Var
        }
        if lineWithoutComments.contains(" let ") || lineWithoutComments.hasPrefix("let ") {
            return PropertyModifier.Let
        }
        return nil
    }
    
    func parsePropertyName(cleanLine: String, propertyModifier: PropertyModifier, declaration: SourceCodeLine) throws -> String {
        let name: String = cleanLine.truncateAllBeforeWord("\(propertyModifier.raw()) ", deleteWord: true).firstWord().replacingOccurrences(of: ":", with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if name.isEmpty {
            throw CompilerMessage(
                absoluteFilePath: declaration.absoluteFilePath,
                lineNumber: declaration.lineNumber,
                message: "[Compiler] Could not parse name of the variable/property",
                type: CompilerMessage.MessageType.Warning
            )
        }
        
        return name
    }
    
}
