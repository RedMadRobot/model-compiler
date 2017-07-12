//
//  SourceCodeFilesReader.swift
//  ModelCompiler
//
//  Created by Jeorge Taflanidy on 20/03/2017.
//  Copyright © 2017 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Utility responsible for source code files reading.
 */
open class SourceCodeFileReader {
    
    open func readSourceCodeFiles(
        filePathList: [String],
        parameters: ExecutionParameters
    ) throws -> [SourceCodeFile] {
        return try filePathList.map { (filePath: String) -> SourceCodeFile in
            return try self.readSourceCodeFile(filePath: filePath, parameters: parameters)
        }
    }
    
    open func readSourceCodeFile(filePath: String, parameters: ExecutionParameters) throws -> SourceCodeFile {
        if parameters.verbose {
            Log.v("Loading file: \(filePath)")
        }
        
        let contents: String = try String(contentsOfFile: filePath)
        return SourceCodeFile(absoluteFilePath: filePath, contents: contents)
    }
    
}
