//
//  ComposerTestCase
//  ModelCompiler
//
//  Created by Jeorge Taflanidi on 5/26/2017 AD.
//  Copyright (c) 2017 RedMadRobot LLC. All rights reserved.
//


import XCTest


class ComposerTestCase: XCTestCase {

    let stubProjectName:     String = "GEN"
    let stubOutputDirectory: String = "dir"

    func composeExpectedImplementation(nameOfFile: String, testExtension: String) -> Implementation {
        return Implementation(
            filePath: self.stubOutputDirectory + "/" + nameOfFile,
            sourceCode: self.composeExpectedSourceCode(nameOfFile: nameOfFile, testExtension: testExtension)
        )
    }

    func composeExpectedSourceCode(nameOfFile: String, testExtension: String) -> String {
        return loadContentsOfFile(name: nameOfFile + testExtension)
    }

    func loadInput(nameOfFile: String) -> SourceCodeFile {
        var stubSwiftLines: [SourceCodeLine] = []

        for (index, line) in self.loadContentsOfFile(name: nameOfFile).lines().enumerated() {
            stubSwiftLines.append(
                SourceCodeLine(
                    absoluteFilePath: "",
                    lineNumber: index,
                    line: line
                )
            )
        }

        return SourceCodeFile(
            absoluteFilePath: "",
            lines: stubSwiftLines
        )
    }

    func loadContentsOfFile(name: String) -> String {
        let path: String = Bundle(for: type(of: self)).path(forResource: name, ofType: nil, inDirectory: nil)!
        return try! String(contentsOfFile: path)
    }

}
