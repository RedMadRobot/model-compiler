// 
// ArgumentParser.swift
// AppCode
// 
// Created by Egor Taflanidi on 05.07.16.
// Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Method arguments' parser.
 */
public class ArgumentParser {

    /**
     Parse lines like
     
     ```
     func method(externalArgumentName argumentName: argumentType = argumentValue, // argument annotations
     ```
     
     ```
     externalArgumentName argumentName: argumentType = argumentValue) -> ReturnType
     ```
     */
    public func parse(rawArguments: [SourceCodeLine]) throws -> [Argument] {
        return try rawArguments
            .map { (rawArgument: SourceCodeLine) -> SourceCodeLine in
                return SourceCodeLine(
                    absoluteFilePath: rawArgument.absoluteFilePath,
                    lineNumber: rawArgument.lineNumber,
                    line: rawArgument.line
                            .truncateAllBeforeWord("(", deleteWord: true)
                            .truncateFromWord(")")
                            .trimmingCharacters(in: CharacterSet.whitespaces)
                )
            }
            .filter { (rawArgument: SourceCodeLine) -> Bool in
                return !rawArgument.line.isEmpty
            }
            .map { (rawArgument: SourceCodeLine) -> Argument in
                return try self.parse(rawArgumentLine: rawArgument)
            }
    }

}

private extension ArgumentParser {
    
    /**
     Parse lines like
     
     ```
     externalArgumentName argumentName: argumentType = argumentValue, // argument annotations
     ```
     */
    func parse(rawArgumentLine line: SourceCodeLine) throws -> Argument {
        var lineStr: String = line.line
        
        let comment:              String
        let argumentName:         String
        let externalArgumentName: String
        
        if lineStr.contains("//") {
            comment = lineStr.truncateAllBeforeWord("//")
        } else {
            comment = ""
        }
        
        let annotations: [Annotation] = AnnotationParser().parse(comment: comment)
        let argumentType: Typê = try TypeParser().parse(rawMethodParameterLine: line)
        
        lineStr = lineStr.truncateFromWord(":")
        
        externalArgumentName = lineStr.firstWord()
        if lineStr.contains(" ") {
            argumentName = lineStr.truncateAllBeforeWord(" ", deleteWord: true)
        } else {
            argumentName = externalArgumentName
        }
        
        return Argument(
            name: externalArgumentName,
            bodyName: argumentName,
            type: argumentType,
            annotations: annotations,
            declaration: line
        )
    }

}
