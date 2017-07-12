//
//  ComposerApplication.swift
//  ModelCompiler
//
//  Created by Jeorge Taflanidy on 20/03/2017.
//  Copyright © 2017 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Base abstract class for all applications that compose helper classes from model objects' source 
 code.
 
 ```ComposerApplication``` instance is supposed to be initialised and launched from ```main.swift``` 
 file by calling it's ```run()``` method.
 
 Sample source code:
 ```swift
 // main.swift
 exit(ComposerApplication().run())
 ```
 
 YOU NEED TO IMPLEMENT / OVERRIDE:
 * **printHelp()** — extend with generator help; call ```super``` beforehand
 * **provideInputFoldersList(fromParameters:)** — return input folder paths from execution parameters
 * **composeUtilities(forObjects:parameters:)** — return composed utility classes
 * **Composer (abstract class)** — make your own composers; use them in ```composeUtilities(forObjects:parameters:)```
 
 */
open class ComposerApplication {
    
    /**
     Override to use own execution parameters.
     */
    open var executionParametersReader: ExecutionParametersReader {
        return ExecutionParametersReader()
    }
    
    /**
     Override to replace or filtrate original ```CommandLine.arguments```
     */
    open var commandLineArguments: [String] {
        return CommandLine.arguments
    }
    
    /**
     Override to change file finding algorithm.
     */
    open var fileFinder: FileFinder {
        return FileFinder()
    }
    
    /**
     Override to enhance conversion of raw files into ```SourceCodeFile``` objects.
     */
    open var sourceCodeFileReader: SourceCodeFileReader {
        return SourceCodeFileReader()
    }
    
    /**
     Override to change file writing process.
     */
    open var fileWriter: FileWriter {
        return FileWriter()
    }
    
    /**
     Application starts here.
     
     Processing includes three steps:
     0. reading execution parameters
     1. reading contents of input directories
     2. compiling found source code into objects
     3. implementing utility classes
     4. writing implemented source code to disk.
     
     Also, application may print help, if you ask politely.
     
     - returns: execution result code.
     */
    public func run() -> Int {
        do {
            let executionParameters: ExecutionParameters = try self.readExecutionParameters()
            
            if executionParameters.printHelp {
                self.printHelp()
                return 0
            }
            
            let inputFolders:         [String]         = try self.provideInputFoldersList(fromParameters: executionParameters)
            let filePathList:         [String]         = try self.findFiles(inFolders: inputFolders, parameters: executionParameters) // NOTE: every file path is absolute
            let sourceCodeFiles:      [SourceCodeFile] = try self.readSourceCodeFiles(filePathList: filePathList, parameters: executionParameters)
            let compiledObjects:      [Klass]          = try self.compile(files: sourceCodeFiles, parameters: executionParameters)
            let implementedUtilities: [Implementation] = try self.composeUtilities(forObjects: compiledObjects, parameters: executionParameters)
            
            try self.write(implementations: implementedUtilities, parameters: executionParameters)
        } catch let error {
            print(error)
            return 1
        }
        return 0
    }
    
    /**
     Get input folders from ```ExecutionParameters```.
     */
    /* abstract */ open func provideInputFoldersList(
        fromParameters parameters: ExecutionParameters
    ) throws -> [String] {
        return []
    }
    
    open func createCompiler(parameters: ExecutionParameters) -> Compiler {
        return Compiler(verbose: parameters.verbose)
    }
    
    /**
     Compose utilities.
     */
    /* abstract */ open func composeUtilities(
        forObjects objects: [Klass],
        parameters: ExecutionParameters
    ) throws -> [Implementation] {
        return []
    }
    
    /**
     Extend to add help information.
     */
    open func printHelp() {
        print("Accepted arguments:")
        print("")
        print("-project_name [name]")
        print("Project name to be used in generated files.")
        print("If not set, 'GEN' is used as a default project name.")
        print("")
        print("-verbose")
        print("Forces application to print additional verbose information: found input files and folders, successfully saved files etc.")
    }
    
}

private extension ComposerApplication {
    
    func readExecutionParameters() throws -> ExecutionParameters {
        return
            try self.executionParametersReader.readExecutionParameters(
                fromCommandLineArguments: self.commandLineArguments
            )
    }
    
    func findFiles(
        inFolders folders: [String],
        parameters: ExecutionParameters
    ) throws -> [String] {
        return
            try self.fileFinder.findFiles(
                inFolders: folders,
                parameters: parameters
            )
    }
    
    func readSourceCodeFiles(
        filePathList: [String],
        parameters: ExecutionParameters
    ) throws -> [SourceCodeFile] {
        return
            try self.sourceCodeFileReader.readSourceCodeFiles(
                filePathList: filePathList,
                parameters: parameters
            )
    }
    
    func compile(files: [SourceCodeFile], parameters: ExecutionParameters) throws -> [Klass] {
        return try self.createCompiler(parameters: parameters).compile(files: files)
    }
    
    func write(implementations: [Implementation], parameters: ExecutionParameters) throws {
        return try self.fileWriter.write(implementations: implementations, parameters: parameters)
    }
    
}
