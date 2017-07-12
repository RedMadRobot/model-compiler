//
//  AnnotationParser.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 30.03.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Utility to parse annotations from comments of any kind.
 */
public class AnnotationParser {
    
    /**
     Initializer.
     */
    public init() {
        // do nothing
    }
    
    /**
     Parse annotations from block and inline comments.
     
     ```
     @annotation
     ```
     
     ```
     @annotation; @annotation
     ```
     
     ```
     @annotation
     @annotation
     ```
     
     ```
     @annotation value
     @annotation
     ```
     
     ```
     @annotation value
     ```
     ```
     @annotation value;
     ```
     ```
     @annotation value @annotation value
     ```
     ```
     @annotation value; @annotation value
     ```
     ```
     @annotation value; @annotation value;
     ```
     */
    public func parse(comment string: String) -> [Annotation] {
        var s:          String       = string
        var annotaions: [Annotation] = []
        
        while s.contains("@") {
            let annotationName: String = s.truncateAllBeforeWord("@", deleteWord: true).firstWord()
            s = s.truncateAllBeforeWord("@" + annotationName, deleteWord: true)
            
            let annotationValue: String?
            
            if s.hasPrefix("\n")
            || s.hasPrefix(" \n")
            || s.hasPrefix(";")
            || s.hasPrefix(";\n")
            || s.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                annotationValue = nil
            } else {
                annotationValue = s.truncateLeadingWhitespace().firstWord(sentenceDividers: ["\n", " ", ";"])
            }
            
            annotaions.append(Annotation(name: annotationName, value: annotationValue))
        }
        
        return annotaions
    }
    
}
