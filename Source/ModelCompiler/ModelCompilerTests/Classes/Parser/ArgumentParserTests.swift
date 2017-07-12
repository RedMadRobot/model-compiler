//
//  ArgumentParserTests.swift
//  ModelCompiler
//
//  Created by Jeorge Taflanidy on 21/03/2017.
//  Copyright © 2017 RedMadRobot LLC. All rights reserved.
//

import XCTest
@testable import ModelCompiler


class ArgumentParserTests: XCTestCase {
    
    let stubFilePath: String = "File.swift"
    let stubLineNumber: Int  = 0
    
    var parser: ArgumentParser { return ArgumentParser() }
    
    func testParse_voidMethodNoArguments_expectedOutput() {
        let sourceCode: String = "func method() {"
        let line: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: stubFilePath,
            lineNumber: stubLineNumber,
            line: sourceCode
        )
        
        do {
            let actualArguments: [Argument] = try parser.parse(rawArguments: [line])
            XCTAssertEqual(actualArguments.count, 0)
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testParse_voidMethodSingleArgument_expectedOutput() {
        let argumentName: String = "argument"
        let sourceCode: String = "func method(\(argumentName): Int) {"
        let line: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: stubFilePath,
            lineNumber: stubLineNumber,
            line: sourceCode
        )
        
        let expectedArgument: Argument = Argument(
            name: argumentName,
            bodyName: argumentName,
            type: Typê.IntType,
            annotations: [],
            declaration: SourceCodeLine(absoluteFilePath: stubFilePath, lineNumber: stubLineNumber, line: "\(argumentName): Int")
        )
        
        do {
            let actualArguments: [Argument] = try parser.parse(rawArguments: [line])
            XCTAssertEqual(actualArguments.count, 1)
            XCTAssertTrue(actualArguments.contains(expectedArgument))
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testParse_voidMethodSingleArgumentWithBodyName_expectedOutput() {
        let argumentName: String = "argument"
        let argumentBodyName: String = "arg"
        let sourceCode: String = "func method(\(argumentName) \(argumentBodyName): Int) {"
        let line: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: stubFilePath,
            lineNumber: stubLineNumber,
            line: sourceCode
        )
        
        let expectedArgument: Argument = Argument(
            name: argumentName,
            bodyName: argumentBodyName,
            type: Typê.IntType,
            annotations: [],
            declaration: SourceCodeLine(absoluteFilePath: stubFilePath, lineNumber: stubLineNumber, line: "\(argumentName) \(argumentBodyName): Int")
        )
        
        do {
            let actualArguments: [Argument] = try parser.parse(rawArguments: [line])
            XCTAssertEqual(actualArguments.count, 1)
            XCTAssertTrue(actualArguments.contains(expectedArgument))
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testParse_initialiserSingleArgument_expectedOutput() {
        let argumentName: String = "name"
        let sourceCode: String = "init(\(argumentName): String) {"
        let line: SourceCodeLine = SourceCodeLine(
            absoluteFilePath: stubFilePath,
            lineNumber: stubLineNumber,
            line: sourceCode
        )
        
        let expectedArgument: Argument = Argument(
            name: argumentName,
            bodyName: argumentName,
            type: Typê.StringType,
            annotations: [],
            declaration: SourceCodeLine(absoluteFilePath: stubFilePath, lineNumber: stubLineNumber, line: "\(argumentName): String")
        )
        
        do {
            let actualArguments: [Argument] = try parser.parse(rawArguments: [line])
            XCTAssertEqual(actualArguments.count, 1)
            XCTAssertTrue(actualArguments.contains(expectedArgument))
        } catch {
            XCTAssertTrue(false)
        }
    }
    
}
