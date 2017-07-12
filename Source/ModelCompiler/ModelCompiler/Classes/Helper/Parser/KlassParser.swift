//
//  KlassParser.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 30.03.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Parse classes, protocols or structures from raw source code.
 */
public class KlassParser {
    
    /**
     Initializer.
     */
    public init() {
        // nothing to do
    }
    
    /**
     Parse raw source code, extract `Klass` from it.
     */
    public func parse(file: SourceCodeFile) throws -> Klass {
        let declaration: SourceCodeLine
        let keyword: String
        
        if let klassDeclaration: SourceCodeLine = self.parseDeclaration(file: file, keyword: "class") {
            declaration = klassDeclaration
            keyword = "class"
        } else if let protocolDeclaration: SourceCodeLine = self.parseDeclaration(file: file, keyword: "protocol") {
            declaration = protocolDeclaration
            keyword = "protocol"
        } else if let protocolDeclaration: SourceCodeLine = self.parseDeclaration(file: file, keyword: "struct") {
            declaration = protocolDeclaration
            keyword = "struct"
        } else {
            throw CompilerMessage(
                absoluteFilePath: file.absoluteFilePath,
                lineNumber: 1,
                message: "[Compiler] File does not contain class, struct or protocol declarations"
            )
        }
        
        let comment: String        = try self.parseComment(file: file, declaration: declaration)
        let name:    String        = try self.parseName(declaration: declaration, keyword: keyword)

        let parents: [String]      = self.parseParents(declaration: declaration, keyword: keyword)
        let body: [SourceCodeLine] = self.parseBody(file: file, declaration: declaration, keyword: keyword)
        
        let annotations: [Annotation] = AnnotationParser().parse(comment: comment)
        let properties:  [Property]   = try PropertyParser().parse(klassBody: body)
        let methods:     [Method]     = try MethodParser(forProtocol: "protocol" == keyword).parse(klassBody: body)
        
        if keyword == "protocol" {
            return Klass(
                type: Klass.KlassType.protokol,
                name: name,
                parents: parents,
                properties: properties,
                annotations: annotations,
                declaration: declaration,
                methods: methods,
                body: body
            )
        }
        
        if keyword == "struct" {
            return Klass(
                type: Klass.KlassType.strukt,
                name: name,
                parents: parents,
                properties: properties,
                annotations: annotations,
                declaration: declaration,
                methods: methods,
                body: body
            )
        }
        
        return Klass(
            type: Klass.KlassType.klass,
            name: name,
            parents: parents,
            properties: properties,
            annotations: annotations,
            declaration: declaration,
            methods: methods,
            body: body
        )
    }
    
}

internal extension KlassParser {
    
    func parseDeclaration(file: SourceCodeFile, keyword: String = "class") -> SourceCodeLine? {
        var inComment: Bool = false
        
        for line in file.lines {
            if !inComment && line.line.contains("/**") {
                inComment = true
            }
            
            if inComment && line.line.contains("*/") {
                inComment = false
            }
            
            if !inComment && line.line.contains("\(keyword) ") {
                return line
            }
        }
        
        return nil
    }
    
    func parseComment(file: SourceCodeFile, declaration: SourceCodeLine) throws -> String {
        var commentLines: [SourceCodeLine] = []
        
        var inComment: Bool = false
        
        for line in file.lines {
            if line.line.contains("/**") {
                inComment = true
                commentLines = []
            }
            
            if inComment {
                commentLines.append(line)
            }
            
            if line.line.contains("*/") {
                inComment = false
            }
            
            if !inComment && line == declaration {
                break
            }
        }
        
        if commentLines.count == 0 {
            throw CompilerMessage(
                absoluteFilePath: file.absoluteFilePath,
                lineNumber: declaration.lineNumber,
                message: "[CodeStyle] Documentation absent"
            )
        }
        
        return commentLines.reduce("", { (comment: String, line: SourceCodeLine) -> String in
            return comment + line.line + "\n"
        })
    }

    func parseName(declaration line: SourceCodeLine, keyword: String = "class") throws -> String {
        guard let name: String = line.line.truncateAllBeforeWord("\(keyword) ", deleteWord: true).components(separatedBy: ":").first?.firstWord()
        else {
            throw CompilerMessage(
                absoluteFilePath: line.absoluteFilePath,
                lineNumber: 1,
                message: "[Compiler] Could not parse class/protocol name"
            )
        }
        
        return name
    }
    
    func parseParents(declaration line: SourceCodeLine, keyword: String) -> [String] {
        if line.line.contains(":") {
            let rawParents: String = line.line
                                            .truncateAllBeforeWord(":", deleteWord: true)
                                            .truncateFromWord("{")
                                            .trimmingCharacters(in: CharacterSet.whitespaces)
            return rawParents
                    .components(separatedBy: ",")
                    .map { (parent: String) -> String in
                        return parent.trimmingCharacters(in: CharacterSet.whitespaces)
                    }
        }
        return []
    }
    
    func parseBody(file: SourceCodeFile, declaration: SourceCodeLine, keyword: String) -> [SourceCodeLine] {
        var body: [SourceCodeLine] = []
        
        let kGlobalScope        = -2
        let kKlassDeclaredScope = -1
        let kKlassScope         = 0
        
        var scope: Int = kGlobalScope
        
        for line in file.lines {
            if line == declaration {
                scope = kKlassDeclaredScope
            }
            
            if line.line.contains("{") && scope >= kKlassDeclaredScope {
                scope = kKlassScope
            }
            
            if scope >= kKlassScope {
                body.append(line)
            }
            
            if line.line.hasPrefix("}") {
                scope -= 1
            }
        }
        
        return body
    }
    
}
