//
//  FileFinderTests.swift
//  ModelCompiler
//
//  Created by Jeorge Taflanidy on 20/03/2017.
//  Copyright © 2017 RedMadRobot LLC. All rights reserved.
//

import XCTest
@testable import ModelCompiler


class FileFinderTests: XCTestCase {
    
    let fileManager: FileManager = FileManager.default
    
    let workingDir:  String = FileManager.default.currentDirectoryPath
    let dirOneLevel: String = "/test_subdir_1/"
    let dirTwoLevel: String = "/test_subdir_2/"
    
    override func setUp() {
        try! fileManager.createDirectory(
            atPath: workingDir + dirOneLevel + dirTwoLevel,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    override func tearDown() {
        try! fileManager.removeItem(atPath: workingDir + dirOneLevel)
        try! fileManager.removeItem(atPath: workingDir + "/test_file1.swift")
    }
    
    func testFind_threeFilesExist_twoFilesFound() {
        let filename1: String = workingDir + "/test_file1.swift"
        let filename2: String = workingDir + dirOneLevel + "test_file2.txt"
        let filename3: String = workingDir + dirOneLevel + dirTwoLevel + "test_file3.SWIfT"
        
        try! "TEST CODE 1".write(toFile: filename1, atomically: true, encoding: String.Encoding.utf8)
        try! "TEST CODE 2".write(toFile: filename2, atomically: true, encoding: String.Encoding.utf8)
        try! "TEST CODE 3".write(toFile: filename3, atomically: true, encoding: String.Encoding.utf8)
        
        let parameters: ExecutionParameters = ExecutionParameters(
            projectName: "TEST PROJECT",
            verbose: true,
            printHelp: false,
            raw: [:]
        )
        
        let fileFinder: FileFinder = FileFinder()
        let foundFiles: [String] = try! fileFinder.findFiles(inFolder: workingDir, parameters: parameters)
        
        XCTAssertEqual(foundFiles.count, 2)
        XCTAssertTrue(foundFiles.contains(filename1))
        XCTAssertTrue(foundFiles.contains(filename3.replacingOccurrences(of: "//", with: "/")))
    }
    
}
