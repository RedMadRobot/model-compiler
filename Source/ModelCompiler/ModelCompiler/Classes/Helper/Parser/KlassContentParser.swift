//
//  KlassContentParser.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 12.07.28.
//  Copyright © 28 Heisei RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Abstract class, which parses class content of any kind.
 
 - seealso: `MethodParser`, `PropertyParser`
 */
open class KlassContentParser<Content> {
    
    /**
     Scan class body.
     */
    open func parse(klassBody lines: [SourceCodeLine]) throws -> [Content] {
        var content: [Content] = []
        
        let kGlobalScope: Int = -1
        let kKlassScope:  Int = 0
        
        var scope: Int = kGlobalScope
        
        var isBlockCommentScope:         Bool = false
        var isDocumentationCommentScope: Bool = false
        
        var lastDocumentationComment: [SourceCodeLine] = []
        
        var parsingContent: Bool = false
        
        for line in lines {
            let cleanLine: String = line.line.truncateFromWord("//")
            
            if isBlockCommentStart(line: cleanLine) && !isBlockCommentScope {
                isBlockCommentScope = true
                lastDocumentationComment = []
            }
            
            if isBlockCommentScope && isDocumentationCommentStart(line: cleanLine) {
                isDocumentationCommentScope = true
            }
            
            if isDocumentationCommentScope {
                lastDocumentationComment.append(line)
            }
            
            if isBlockCommentEnd(line: cleanLine) {
                isDocumentationCommentScope = false
                isBlockCommentScope         = false
            }
            
            if scope == kKlassScope && !isBlockCommentScope && self.detectContent(line: line) {
                parsingContent = true
            }
            
            if !isBlockCommentScope && cleanLine.contains("{") {
                scope += 1
            }
            
            if parsingContent {
                self.appendContent(line: line)
            }
            
            if parsingContent {
                if let parsedContent = try self.endedParsingContent(line: line, documentation: lastDocumentationComment) {
                    content.append(parsedContent)
                    parsingContent = false
                }
            }
            
            if !isBlockCommentScope && cleanLine.contains("}") {
                scope -= 1
            }
        }
        
        return content
    }
    
    /**
     Abstract method to detect method or property declaration.
     */
    open func detectContent(line: SourceCodeLine) -> Bool {
        fatalError("Abstract method")
    }
    
    /**
     Abstract method to append raw content of method or property.
     */
    open func appendContent(line: SourceCodeLine) {
        fatalError("Abstract method")
    }
    
    /**
     Abstract method to return parsed method or property.
     */
    open func endedParsingContent(line: SourceCodeLine, documentation: [SourceCodeLine]) throws -> Content? {
        fatalError("Abstract method")
    }
    
}

internal extension KlassContentParser {
    
    func isBlockCommentStart(line: String) -> Bool {
        var cleanLine: String = line
        
        while let match = cleanLine.range(of: "\"(.*)\"", options: .regularExpression) {
            cleanLine = cleanLine.replacingCharacters(in: match, with: "")
        }
        
        return cleanLine.contains("/*")
    }
    
    func isDocumentationCommentStart(line: String) -> Bool {
        var cleanLine: String = line
        
        while let match = cleanLine.range(of: "\"(.*)\"", options: .regularExpression) {
            cleanLine = cleanLine.replacingCharacters(in: match, with: "")
        }
        
        return cleanLine.contains("/**")
    }
    
    func isBlockCommentEnd(line: String) -> Bool {
        var cleanLine: String = line
        
        while let match = cleanLine.range(of: "\"(.*)\"", options: .regularExpression) {
            cleanLine = cleanLine.replacingCharacters(in: match, with: "")
        }
        
        return cleanLine.contains("*/")
    }
    
}

