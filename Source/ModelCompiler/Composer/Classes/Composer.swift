//
//  Composer.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 09.03.29.
//  Copyright © 29 Heisei RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Abstract class responsible for composing source code.
 
 Implements header comment generation with copyright information and imports Foundation into 
 generated code.
 
 Provides basic utility class structure separation, allows to override utility class filename 
 generation, allows to extend imports and implement source code generation.
 */
open class Composer {
    
    /**
     Compose utility class source code.
     
     - parameter entityKlass: entity class model for which utility should be composed;
     - parameter entityKlasses: other entity classes available in scope;
     - parameter projectName: project name.
     
     - returns: `Implementation` object with utility class source code and filename.
     */
    public func composeEntityUtilityImplementation(
        forEntityKlass entityKlass: Klass,
        availableEntityKlasses entityKlasses: [Klass],
        projectName: String,
        outputDirectory: String
    ) throws -> Implementation {
        let filename: String = composeEntityUtilityFilename(forEntityKlass: entityKlass)
        let path: String = outputDirectory.hasSuffix("/") ? outputDirectory + filename : outputDirectory + "/" + filename
        let sourceCode: String =
            try
                composeCopyrightComment(forFilename: filename, project: projectName).addBlankLine() +
                composeImports().addBlankLine().addBlankLine() +
                composeUtilitySourceCode(forEntityKlass: entityKlass, availableEntityKlasses: entityKlasses)
        
        return Implementation(
            filePath: path,
            sourceCode: sourceCode
        )
    }
    
    /**
     Compose utility class filename.
     
     - parameter entityKlass: entity class model for which utility is composed.
     
     - returns: By default, returns entity class name + "Util.swift".
     */
    open func composeEntityUtilityFilename(forEntityKlass entityKlass: Klass) -> String {
        return entityKlass.name + "Util.swift"
    }
    
    /**
     Compose copytight comment header.
     
     - returns: Comment with project & file names, "Created by Code Generator" and 
     "Copyright RedMadRobot".
     */
    open func composeCopyrightComment(forFilename filename: String, project: String) -> String {
        return ""
            .addLine("//")
            .addLine("//  \(filename)")
            .addLine("//  \(project)")
            .addLine("//")
            .addLine("//  Created by Code Generator")
            .addLine("//  Copyright (c) 2017 RedMadRobot LLC. All rights reserved.")
            .addLine("//")
    }
    
    /**
     Compose import declarations.
     
     - returns: `import Foundation` by default.
     */
    open func composeImports() -> String {
        return ""
            .addLine("import Foundation")
    }
    
    /**
     Abstract method to compose utility class source code.
     
     - parameter entityKlass: entity class model for which utility is composed;
     - parameter entityKlasses: other entity classes available in scope.
     
     - returns: Utility class body source code withoud class declaration.
     */
    open func composeUtilitySourceCode(
        forEntityKlass entityKlass: Klass,
        availableEntityKlasses entityKlasses: [Klass]
    ) throws -> String {
        return ""
    }
    
}
