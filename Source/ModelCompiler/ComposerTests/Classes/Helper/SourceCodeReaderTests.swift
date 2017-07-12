//
//  SourceCodeReaderTests.swift
//  ModelCompiler
//
//  Created by Jeorge Taflanidy on 20/03/2017.
//  Copyright © 2017 RedMadRobot LLC. All rights reserved.
//

import XCTest
@testable import ModelCompiler


class SourceCodeReaderTests: XCTestCase {
    
    let workingDir: String = FileManager.default.currentDirectoryPath
    let filename: String = "a.swift"
    
    let line1: String = "class ABC: Entity {"
    let line2: String = "}"
    let line3: String = ""
    var sourceCode: String { return line1 + "\n" + line2 + "\n" + line3 }
    
    override func setUp() {
        try! sourceCode.write(toFile: workingDir + "/" + filename, atomically: true, encoding: String.Encoding.utf8)
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(atPath: workingDir + "/" + filename)
    }
    
    func testRead_file_returnsSourceCodeFile() {
        let reader: SourceCodeFileReader = SourceCodeFileReader()
        let parameters: ExecutionParameters = ExecutionParameters(
            projectName: "TEST PROJECT",
            verbose: true,
            printHelp: false,
            raw: [:]
        )
        
        let sourceCodeFile: SourceCodeFile = try! reader.readSourceCodeFile(filePath: workingDir + "/" + filename, parameters: parameters)
        let expectedFile: SourceCodeFile = SourceCodeFile(
            absoluteFilePath: workingDir + "/" + filename,
            contents: sourceCode
        )
        
        XCTAssertEqual(sourceCodeFile, expectedFile)
    }
    
}
