//
//  Compiler.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 30.03.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Converts `SourceCodeFile` to `Klass` entities.
 */
public class Compiler {
    
    /**
     Print each found class, property, method and argument as warnings.
     */
    fileprivate let verbose: Bool

    /**
     Initializer. 
     - parameter verbose: verbosity level, see `Compiler.verbose` property.
     */
    public init(verbose: Bool) {
        self.verbose = verbose
    }
    
    /**
     Convert an array of `SourceCodeFile` to an array of `Klass` instances.
     Scans source code for classes, properties and methods using corresponding parsers.
     
     - parameter files: array of `SourceCodeFile` to be scanned.
     
     - returns: array of `Klass` instances.
     
     - throws: `CompilerMessage` in case when source code scan failed for some reason; search parser
     utilities for `throw CompilerMessage` line.
     */
    public func compile(files: [SourceCodeFile]) throws -> [Klass] {
        return try files.compactMap { (file: SourceCodeFile) -> Klass? in
            return try self.compile(file: file)
        }
    }
    
    /**
     Convert `SourceCodeFile` to `Klass` instances.
     Scans source code for classes, properties and methods using corresponding parsers.
     
     - parameter file: `SourceCodeFile` to be scanned.
     
     - returns: found `Klass` instance, if any.
     
     - throws: `CompilerMessage` in case when source code scan failed for some reason; search parser
     utilities for `throw CompilerMessage` line
     */
    public func compile(file: SourceCodeFile) throws -> Klass? {
        if self.shouldIgnore(file: file) {
            return nil
        }
        
        let klass: Klass = try KlassParser().parse(file: file)
        self.verbosePrint(klass: klass)
        return klass
    }
    
}

private extension Compiler {
    
    func shouldIgnore(file: SourceCodeFile) -> Bool {
        for line in file.lines {
            if line.line.contains("@ignore") {
                return true
            }
        }
        return false
    }

    func verbosePrint(klass: Klass) {
        guard self.verbose
        else { return }
        
        let klassMessage: CompilerMessage = CompilerMessage(
            line: klass.declaration,
            message: "\(klass)",
            type: .Warning
        )
        
        let propertyMessages: [CompilerMessage] = klass.properties
            .map { (property: Property) -> CompilerMessage in
                return CompilerMessage(
                    line: property.declaration,
                    message: "\(property)",
                    type: .Warning
                )
        }
        
        let methodMessages: [CompilerMessage] = klass.methods
            .map { (method: Method) -> CompilerMessage in
                return CompilerMessage(
                    line: method.declaration,
                    message: "\(method)",
                    type: .Warning
                )
        }
        
        let argumentMessages: [CompilerMessage] = klass.methods
            .reduce([]) { (initial: [CompilerMessage], method: Method) -> [CompilerMessage] in
                return initial + method.arguments.map { (argument: Argument) -> CompilerMessage in
                    return CompilerMessage(
                        line: argument.declaration,
                        message: "\(argument)",
                        type: .Warning
                    )
                }
        }
        
        print("\(klassMessage)")
        
        propertyMessages.forEach { print("\($0)") }
        methodMessages.forEach   { print("\($0)") }
        argumentMessages.forEach { print("\($0)") }
    }

}
