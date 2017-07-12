//
//  PropertyParserTests.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 13.03.29.
//  Copyright © 29 Heisei RedMadRobot LLC. All rights reserved.
//

import XCTest
@testable import ModelCompiler


class PropertyParserTests: XCTestCase {
    
    let stubFilePath:   String = "File.swift"
    let stubLineNumber: Int    = 0
    
    func testDetectContent_lineHasPrefixPropertyModifierVar_returnsTrue() {
        let input: String = "var variable: Int"
        let line: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: stubFilePath,
            lineNumber: stubLineNumber,
            line: input
        )
        
        let result: Bool = PropertyParser().detectContent(line: line)
        XCTAssertTrue(result)
    }
    
    func testDetectContent_lineHasPrefixPropertyModifierLet_returnsTrue() {
        let input: String = "let variable: Int"
        let line: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: stubFilePath,
            lineNumber: stubLineNumber,
            line: input
        )
        
        let result: Bool = PropertyParser().detectContent(line: line)
        XCTAssertTrue(result)
    }
    
    func testDetectContent_lineContainsPropertyModifierVar_returnsTrue() {
        let input: String = "blah blah var variable: Int"
        let line: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: stubFilePath,
            lineNumber: stubLineNumber,
            line: input
        )
        
        let result: Bool = PropertyParser().detectContent(line: line)
        XCTAssertTrue(result)
    }
    
    func testDetectContent_lineContainsPropertyModifierLet_returnsTrue() {
        let input: String = "blah blah let variable: Int"
        let line: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: stubFilePath,
            lineNumber: stubLineNumber,
            line: input
        )
        
        let result: Bool = PropertyParser().detectContent(line: line)
        XCTAssertTrue(result)
    }
    
    func testDetectContent_lineContainsPropertyModifierVarCommentedOut_returnsFalse() {
        let input: String = "//blah blah var variable: Int"
        let line: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: stubFilePath,
            lineNumber: stubLineNumber,
            line: input
        )
        
        let result: Bool = PropertyParser().detectContent(line: line)
        XCTAssertFalse(result)
    }
    
    func testEndedParsingContent_fullLine_returnsProperty() {
        let input: String = "let variable: Int // @hello variable"
        let line: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: stubFilePath,
            lineNumber: stubLineNumber,
            line: input
        )
        
        let result: Property? = try! PropertyParser().endedParsingContent(line: line, documentation: [])
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.constant, true)
        XCTAssertEqual(result!.name, "variable")
        XCTAssertEqual(result!.type, Typê.IntType)
        XCTAssertEqual(result!.declaration, line)
        XCTAssertEqual(result!.annotations, [Annotation(name: "hello", value: "variable")])
    }
    
    func testEndedParsingContent_twoSpacesBeforeVariableName_throws() {
        let input: String = "let  variable: Int // @hello variable"
        let line: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: stubFilePath,
            lineNumber: stubLineNumber,
            line: input
        )
        
        do {
            _ = try PropertyParser().endedParsingContent(line: line, documentation: [])
            XCTAssertTrue(false)
        } catch let message as CompilerMessage {
            XCTAssertEqual(
                message,
                CompilerMessage(
                    absoluteFilePath: stubFilePath,
                    lineNumber: stubLineNumber,
                    message: "[Compiler] Could not parse name of the variable/property",
                    type: CompilerMessage.MessageType.Warning
                )
            )
        } catch {
            XCTAssertTrue(false)
        }
    }
    
}
