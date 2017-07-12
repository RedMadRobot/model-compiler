//
//  AnnotationParserTests.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 09.03.29.
//  Copyright © 29 Heisei RedMadRobot LLC. All rights reserved.
//

import XCTest
@testable import ModelCompiler


class AnnotationParserTests: XCTestCase {
    
    func testParse_singleAnnotation_expectedResult() {
        let comment: String = "/**"
                     .addLine(" Some text")
                     .addLine(" @annotation")
                     .addLine(" Another text")
                     .addLine(" */")
        let actualAnnotations: [Annotation] = AnnotationParser().parse(comment: comment)
        
        let expectedAnnotations: [Annotation] = [
            Annotation(name: "annotation", value: nil)
        ]
        
        XCTAssertEqual(actualAnnotations, expectedAnnotations)
    }
    
    func testParse_singleAnnotationWithValue_expectedResult() {
        let comment: String = "/**"
                     .addLine(" Some text")
                     .addLine(" @annotation value")
                     .addLine(" Another text")
                     .addLine(" */")
        let actualAnnotations: [Annotation] = AnnotationParser().parse(comment: comment)
        
        let expectedAnnotations: [Annotation] = [
            Annotation(name: "annotation", value: "value")
        ]
        
        XCTAssertEqual(actualAnnotations, expectedAnnotations)
    }
    
    func testParse_twoAnnotations_expectedResult() {
        let comment: String = "/**"
                     .addLine(" Some text")
                     .addLine(" @annotation")
                     .addLine(" @annotation_two")
                     .addLine(" Another text")
                     .addLine(" */")
        let actualAnnotations: [Annotation] = AnnotationParser().parse(comment: comment)
        
        let expectedAnnotations: [Annotation] = [
            Annotation(name: "annotation", value: nil),
            Annotation(name: "annotation_two", value: nil)
        ]
        
        XCTAssertEqual(actualAnnotations, expectedAnnotations)
    }
    
    func testParse_twoAnnotationsSingleLine_expectedResult() {
        let comment: String = "/**"
                     .addLine(" Some text")
                     .addLine(" @annotation; @annotation_two")
                     .addLine(" Another text")
                     .addLine(" */")
        let actualAnnotations: [Annotation] = AnnotationParser().parse(comment: comment)
        
        let expectedAnnotations: [Annotation] = [
            Annotation(name: "annotation", value: nil),
            Annotation(name: "annotation_two", value: nil)
        ]
        
        XCTAssertEqual(actualAnnotations, expectedAnnotations)
    }

    func testParse_twoAnnotationsSingleLineWithValues_expectedResult() {
        let comment: String = "/**"
                     .addLine(" Some text")
                     .addLine(" @annotation value; @annotation_two value_two")
                     .addLine(" Another text")
                     .addLine(" */")
        let actualAnnotations: [Annotation] = AnnotationParser().parse(comment: comment)
        
        let expectedAnnotations: [Annotation] = [
            Annotation(name: "annotation", value: "value"),
            Annotation(name: "annotation_two", value: "value_two")
        ]
        
        XCTAssertEqual(actualAnnotations, expectedAnnotations)
    }
    
    func testParse_twoAnnotationsSingleLineWithValuesNoSemicolon_expectedResult() {
        let comment: String = "/**"
                     .addLine(" Some text")
                     .addLine(" @annotation value @annotation_two value_two")
                     .addLine(" Another text")
                     .addLine(" */")
        let actualAnnotations: [Annotation] = AnnotationParser().parse(comment: comment)
        
        let expectedAnnotations: [Annotation] = [
            Annotation(name: "annotation", value: "value"),
            Annotation(name: "annotation_two", value: "value_two")
        ]
        
        XCTAssertEqual(actualAnnotations, expectedAnnotations)
    }

    func testParse_twoAnnotationsSingleLineWithValuesInlineCommentNoSemicolon_expectedResult() {
        let comment: String = "// Some text @annotation value @annotation_two value_two Another text"
        let actualAnnotations: [Annotation] = AnnotationParser().parse(comment: comment)
        
        let expectedAnnotations: [Annotation] = [
            Annotation(name: "annotation", value: "value"),
            Annotation(name: "annotation_two", value: "value_two")
        ]
        
        XCTAssertEqual(actualAnnotations, expectedAnnotations)
    }
    
    func testParse_twoAnnotationsSingleLineWithValuesInlineComment_expectedResult() {
        let comment: String = "// Some text @annotation value; @annotation_two value_two Another text"
        let actualAnnotations: [Annotation] = AnnotationParser().parse(comment: comment)
        
        let expectedAnnotations: [Annotation] = [
            Annotation(name: "annotation", value: "value"),
            Annotation(name: "annotation_two", value: "value_two")
        ]
        
        XCTAssertEqual(actualAnnotations, expectedAnnotations)
    }
    
}
