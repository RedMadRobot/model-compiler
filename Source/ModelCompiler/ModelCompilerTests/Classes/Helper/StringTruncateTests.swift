//
//  String+TruncateTests.swift
//  ModelCompilerTests
//
//  Created by Anton Glezman on 23.04.2018.
//  Copyright © 2018 RedMadRobot LLC. All rights reserved.
//

import XCTest
@testable import ModelCompiler

class StringTruncateTests: XCTestCase {
    
    func testTruncateAllBeforeWord_deleteWordFalse_equalsExpectedResult() {
        let sourceStr = "text @annotation name"
        let result = sourceStr.truncateAllBeforeWord("@annotation", deleteWord: false)
        XCTAssertEqual(result, "@annotation name")
    }
    
    func testTruncateAllBeforeWord_deleteWordTrue_equalsExpectedResult() {
        let sourceStr = "text @annotation name"
        let result = sourceStr.truncateAllBeforeWord("@annotation", deleteWord: true)
        XCTAssertEqual(result, " name")
    }
    
    func testTruncateAllBeforeWord_withoutWord_equalsExpectedResult() {
        let sourceStr = "text annotation name"
        let result = sourceStr.truncateAllBeforeWord("@annotation", deleteWord: true)
        XCTAssertEqual(result, "text annotation name")
    }
    
    func testTruncateFromWord_deleteWordFalse_equalsExpectedResult() {
        let sourceStr = "code //comment"
        let result = sourceStr.truncateFromWord("//", deleteWord: false)
        XCTAssertEqual(result, "code //")
    }
    
    func testTruncateFromWord_deleteWordTrue_equalsExpectedResult() {
        let sourceStr = "code //comment"
        let result = sourceStr.truncateFromWord("//", deleteWord: true)
        XCTAssertEqual(result, "code ")
    }
    
    func testTruncateFromWord_withoutWord_equalsExpectedResult() {
        let sourceStr = "code comment"
        let result = sourceStr.truncateFromWord("//", deleteWord: true)
        XCTAssertEqual(result, "code comment")
    }
    
    func testLastWord_afterSpace_equalsExpectedResult() {
        let sourceStr = "first second third"
        let result = sourceStr.lastWord()
        XCTAssertEqual(result, "third")
    }
    
    func testLastWord_afterLineBreak_equalsExpectedResult() {
        let sourceStr = "first second\nthird"
        let result = sourceStr.lastWord()
        XCTAssertEqual(result, "third")
    }
    
    func testFirstWord_beforeSpace_equalsExpectedResult() {
        let sourceStr = "first second third"
        let result = sourceStr.firstWord()
        XCTAssertEqual(result, "first")
    }
    
    func testFirstWord_beforeDivider_equalsExpectedResult() {
        let sourceStr = "first.second.third"
        let result = sourceStr.firstWord(sentenceDividers: ["."])
        XCTAssertEqual(result, "first")
    }
    
    func testEnumerateWords_equalsExpectedResult() {
        let sourceStr = "first line\n" +
                        "second line"
        
        var result = [String]()
        sourceStr.enumerateWords { (word) in
            result.append(word)
        }
        
        let expectedResult = ["first", "line", "\n", "second", "line", "\n"]
        XCTAssertEqual(result, expectedResult)
    }
    
    func testTruncateLeadingWhitespace_multipleSpaces_equalsExpectedResult() {
        let sourceStr = " \n  \n text"
        let result = sourceStr.truncateLeadingWhitespace()
        XCTAssertEqual(result, "text")
    }
    
    func testTruncateToWordFromBehind_deleteWordFalse_equalsExpectedResult() {
        let sourceStr = "text @annotation name"
        let result = sourceStr.truncateToWordFromBehind("@annotation", deleteWord: false)
        XCTAssertEqual(result, "text @annotation")
    }
    
    func testTruncateToWordFromBehind_deleteWordTrue_equalsExpectedResult() {
        let sourceStr = "text @annotation name"
        let result = sourceStr.truncateToWordFromBehind("@annotation", deleteWord: true)
        XCTAssertEqual(result, "text ")
    }
    
    func testTruncateUntilWord_equalsExpectedResult() {
        let sourceStr = "text @annotation name"
        let result = sourceStr.truncateUntilWord("@annotation")
        XCTAssertEqual(result, "@annotation name")
    }
}
