//
//  FileWriterTests.swift
//  ModelCompiler
//
//  Created by Jeorge Taflanidy on 20/03/2017.
//  Copyright © 2017 RedMadRobot LLC. All rights reserved.
//

import XCTest
@testable import ModelCompiler


class FileWriterTests: XCTestCase {
    
    let workingDir: String = FileManager.default.currentDirectoryPath
    let subdir:     String = "/test_subdir/"
    let filename:   String = "TestFile.swift"
    var filepath:   String { return workingDir + subdir + filename }
    
    override func setUp() {
        try? FileManager.default.removeItem(atPath: filepath)
        try? FileManager.default.removeItem(atPath: workingDir + subdir)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(atPath: filepath)
        try? FileManager.default.removeItem(atPath: workingDir + subdir)
    }
    
    func testWrite_fileNotExist_fileCreated() {
        let writer: FileWriter = FileWriter()
        let sourcecode: String = "TEST CODE"
        
        let implementation: Implementation = Implementation(filePath: filepath, sourceCode: sourcecode)
        let parameters: ExecutionParameters = ExecutionParameters(
            projectName: "TEST PROJECT",
            verbose: true,
            printHelp: false,
            raw: [:]
        )
        
        do {
            try writer.write(implementations: [implementation], parameters: parameters)
        } catch {
            XCTAssertTrue(false)
        }
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: filepath))
        XCTAssertEqual(sourcecode, try! String(contentsOfFile: filepath))
    }
    
}
