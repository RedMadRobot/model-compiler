//
//  TypeParserTests.swift
//  ModelCompiler
//
//  Created by Jeorge Taflanidy on 06/03/2017.
//  Copyright © 2017 RedMadRobot LLC. All rights reserved.
//

import XCTest
@testable import ModelCompiler


class TypeParserTests: XCTestCase {
    
    let stubFilePath: String = "File.swift"
    let stubLineNumber: Int  = 0
    
    func testParseVariableLine_explicitBoolType_equalsExpectedResult() {
        let line: String = "var name: Bool"
        let expectedType: Typê = Typê.BoolType
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitOptionalBoolType_equalsExpectedResult() {
        let line: String = "var name: Bool?"
        let expectedType: Typê = Typê.OptionalType(wrapped: Typê.BoolType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitIntType_equalsExpectedResult() {
        let line: String = "var name: Int"
        let expectedType: Typê = Typê.IntType
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitOptionalIntType_equalsExpectedResult() {
        let line: String = "var name: Int?"
        let expectedType: Typê = Typê.OptionalType(wrapped: Typê.IntType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitFloatType_equalsExpectedResult() {
        let line: String = "var name: Float"
        let expectedType: Typê = Typê.FloatType
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitOptionalFloatType_equalsExpectedResult() {
        let line: String = "var name: Float?"
        let expectedType: Typê = Typê.OptionalType(wrapped: Typê.FloatType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitDoubleType_equalsExpectedResult() {
        let line: String = "var name: Double"
        let expectedType: Typê = Typê.DoubleType
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitOptionalDoubleType_equalsExpectedResult() {
        let line: String = "var name: Double?"
        let expectedType: Typê = Typê.OptionalType(wrapped: Typê.DoubleType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitStringType_equalsExpectedResult() {
        let line: String = "var name: String"
        let expectedType: Typê = Typê.StringType
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitOptionalStringType_equalsExpectedResult() {
        let line: String = "var name: String?"
        let expectedType: Typê = Typê.OptionalType(wrapped: Typê.StringType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitDateType_equalsExpectedResult() {
        let line: String = "var name: Date"
        let expectedType: Typê = Typê.DateType
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitOptionalDateType_equalsExpectedResult() {
        let line: String = "var name: Date?"
        let expectedType: Typê = Typê.OptionalType(wrapped: Typê.DateType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitDataType_equalsExpectedResult() {
        let line: String = "var name: Data"
        let expectedType: Typê = Typê.DataType
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitOptionalDataType_equalsExpectedResult() {
        let line: String = "var name: Data?"
        let expectedType: Typê = Typê.OptionalType(wrapped: Typê.DataType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitObjectType_equalsExpectedResult() {
        let line: String = "var name: Entity"
        let expectedType: Typê = Typê.ObjectType(name: "Entity")
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitOptionalObjectType_equalsExpectedResult() {
        let line: String = "var name: Entity?"
        let expectedType: Typê = Typê.OptionalType(wrapped: Typê.ObjectType(name: "Entity"))
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
}
