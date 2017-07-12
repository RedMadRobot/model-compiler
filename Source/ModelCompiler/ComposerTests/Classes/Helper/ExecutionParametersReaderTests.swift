//
//  ExecutionParametersReaderTests.swift
//  ModelCompiler
//
//  Created by Jeorge Taflanidy on 20/03/2017.
//  Copyright © 2017 RedMadRobot LLC. All rights reserved.
//

import XCTest
@testable import ModelCompiler


class ExecutionParametersReaderTests: XCTestCase {
    
    func testReadExecutionParameters_allSet_returnsCorrectParameters() {
        let projectName: String = "test_name"
        
        let key1:   String = "-key1"
        let key2:   String = "-key2"
        let value2: String = "value2"
        
        let commandLineArguments: [String] = [
            "-project_name",
            projectName,
            "-verbose",
            key1,
            key2,
            value2
        ]
        
        let reader: ExecutionParametersReader = ExecutionParametersReader()
        
        let parameters: ExecutionParameters = try! reader.readExecutionParameters(fromCommandLineArguments: commandLineArguments)
        let expectedParameters: ExecutionParameters = ExecutionParameters(
            projectName: projectName,
            verbose: true,
            printHelp: false,
            raw: [
                "-project_name": projectName,
                "-verbose": "",
                key1: "",
                key2: value2
            ]
        )
        
        XCTAssertEqual(parameters, expectedParameters)
        XCTAssertEqual(parameters[key2], value2)
    }
    
}
