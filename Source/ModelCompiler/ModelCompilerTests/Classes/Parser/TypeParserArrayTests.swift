//
//  TypeParserCollectionTests.swift
//  ModelCompiler
//
//  Created by Jeorge Taflanidy on 07/03/2017.
//  Copyright © 2017 RedMadRobot LLC. All rights reserved.
//

import XCTest
@testable import ModelCompiler

class TypeParserArrayTests: XCTestCase {
    
    let stubFilePath: String = "File.swift"
    let stubLineNumber: Int  = 0
    
    func testParseVariableLine_explicitBoolCollectionType_equalsExpectedResult() {
        let line: String = "var name: [Bool]"
        let expectedType: Typê = Typê.ArrayType(item: Typê.BoolType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitIntCollectionType_equalsExpectedResult() {
        let line: String = "var name: [Int]"
        let expectedType: Typê = Typê.ArrayType(item: Typê.IntType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitFloatCollectionType_equalsExpectedResult() {
        let line: String = "var name: [Float]"
        let expectedType: Typê = Typê.ArrayType(item: Typê.FloatType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitDoubleCollectionType_equalsExpectedResult() {
        let line: String = "var name: [Double]"
        let expectedType: Typê = Typê.ArrayType(item: Typê.DoubleType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitStringCollectionType_equalsExpectedResult() {
        let line: String = "var name: [String]"
        let expectedType: Typê = Typê.ArrayType(item: Typê.StringType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitDateCollectionType_equalsExpectedResult() {
        let line: String = "var name: [Date]"
        let expectedType: Typê = Typê.ArrayType(item: Typê.DateType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitDataCollectionType_equalsExpectedResult() {
        let line: String = "var name: [Data]"
        let expectedType: Typê = Typê.ArrayType(item: Typê.DataType)
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitObjectCollectionType_equalsExpectedResult() {
        let line: String = "var name: [Entity]"
        let expectedType: Typê = Typê.ArrayType(item: Typê.ObjectType(name: "Entity"))
        
        let actualType: Typê = try! TypeParser().parse(
            rawVariableLine: SourceCodeLine(
                absoluteFilePath: stubFilePath,
                lineNumber: stubLineNumber,
                line: line
            )
        )
        
        XCTAssertEqual(actualType, expectedType)
    }
    
    func testParseVariableLine_explicitOptionalObjectCollectionType_equalsExpectedResult() {
        let line: String = "var name: [Entity?]"
        let expectedType: Typê = Typê.ArrayType(item: Typê.OptionalType(wrapped: Typê.ObjectType(name: "Entity")))
        
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
