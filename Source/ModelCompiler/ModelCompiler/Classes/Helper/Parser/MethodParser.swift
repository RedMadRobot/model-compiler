// 
// MethodParser.swift
// AppCode
// 
// Created by Egor Taflanidi on 05.07.16.
// Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Finds methods in class body.
 */
open class MethodParser: KlassContentParser<Method> {
    
    fileprivate var openCurlyBraces: Int = 0
    fileprivate var openRoundBraces: Int = 0
    fileprivate var isBlockCommentScope: Bool = false
    
    fileprivate var declaration: SourceCodeLine? = nil
    fileprivate var methodBody: [SourceCodeLine] = []
    fileprivate var arguments:  [SourceCodeLine] = []
    fileprivate var returnType: SourceCodeLine?  = nil
    
    private let isProtocol: Bool
    
    init(forProtocol: Bool) {
        self.isProtocol = forProtocol
    }

    open override func detectContent(line: SourceCodeLine) -> Bool {
        let cleanLine: String = line.line.truncateFromWord("//")
        let detect: Bool = cleanLine.contains(" func ")
                        || cleanLine.contains(" init(")
        
        if detect {
            self.declaration = line
        }
        
        return detect
    }
    
    open override func appendContent(line: SourceCodeLine) {
        let cleanLine: String = line.line.truncateFromWord("//")
        self.isBlockCommentScope = self.isBlockCommentStart(line: cleanLine) || self.isBlockCommentScope
        
        if !self.isBlockCommentScope {
            if cleanLine.contains("(") {
                if nil == cleanLine.range(of: "\"(.*)((.*)\"", options: .regularExpression) {
                    self.openRoundBraces += 1
                }
            }
        }
        
        if self.openRoundBraces > 0 && self.openCurlyBraces <= 0 {
            self.arguments.append(line)
        }
        
        if !self.isBlockCommentScope {
            if cleanLine.contains("{") {
                if nil == cleanLine.range(of: "\"(.*){(.*)\"", options: .regularExpression) {
                    self.openCurlyBraces += 1
                }
            }
        }
        
        if !self.isBlockCommentScope {
            let currentLine: String = cleanLine.truncateAllBeforeWord(")").truncateLeadingWhitespace()
            if currentLine.contains("->") {
                self.returnType = line
            }
        }
        
        if self.openCurlyBraces > 0 {
            self.methodBody.append(line)
        }
        
        if !self.isBlockCommentScope {
            if cleanLine.contains(")") {
                if nil == cleanLine.range(of: "\"(.*))(.*)\"", options: .regularExpression) {
                    self.openRoundBraces -= 1
                }
            }
        }
        
        if !self.isBlockCommentScope {
            if cleanLine.contains("}") {
                if nil == cleanLine.range(of: "\"(.*)}(.*)\"", options: .regularExpression) {
                    self.openCurlyBraces -= 1
                }
            }
        }
        
        self.isBlockCommentScope = self.isBlockCommentEnd(line: cleanLine) ? false : self.isBlockCommentScope
    }
    
    open override func endedParsingContent(line: SourceCodeLine, documentation: [SourceCodeLine]) throws -> Method? {
        let cleanLine: String = line.line.truncateFromWord("//")
        guard !self.isBlockCommentScope
            && self.openCurlyBraces == 0
            && self.openRoundBraces == 0
            && (cleanLine.contains("}") || self.isProtocol)
            && nil != self.declaration
        else { return nil }
        
        let lastBlockComment: String = documentation.reduce("", {
            (comment: String, line: SourceCodeLine) -> String in
            return comment + line.line + "\n"
        })
        
        let annotations: [Annotation] = AnnotationParser().parse(comment: lastBlockComment)
        
        let name: String
        let arguments: [Argument]
        let returnType: Typê?
        
        if self.declaration!.line.contains(" init(") {
            name = "init"
            returnType = .ObjectType(name: "Self")
        } else {
            name = self.declaration!.line.truncateAllBeforeWord(" func ", deleteWord: true).truncateFromWord("(")
            returnType = try self.findReturnType(declaration: self.returnType)
        }
        
        arguments = try ArgumentParser().parse(rawArguments: self.arguments)
        
        let declaration:    SourceCodeLine      = self.declaration!
        let body:           [SourceCodeLine]    = self.methodBody
        
        self.cleanStateToParseNextMethod()
        
        return Method(
            name: name,
            arguments: arguments,
            annotations: annotations,
            returnType: returnType,
            declaration: declaration,
            body: body
        )
    }
    
}

private extension MethodParser {

    func findReturnType(declaration: SourceCodeLine?) throws -> Typê? {
        guard let typeDeclaration: SourceCodeLine = declaration
        else { return nil }

        let rawType: String = typeDeclaration.line.truncateAllBeforeWord("->", deleteWord: true).truncateFromWord("{").trimmingCharacters(in: CharacterSet.whitespaces)
        let rawTypeDeclaration: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: typeDeclaration.absoluteFilePath,
            lineNumber: typeDeclaration.lineNumber,
            line: rawType
        )

        return try TypeParser().parse(rawType: rawType, declaration: rawTypeDeclaration)
    }
    
    func cleanStateToParseNextMethod() {
        self.openCurlyBraces = 0
        self.openRoundBraces = 0
        self.isBlockCommentScope = false
        self.declaration = nil
        self.methodBody = []
        self.arguments = []
        self.returnType = nil
    }

}
