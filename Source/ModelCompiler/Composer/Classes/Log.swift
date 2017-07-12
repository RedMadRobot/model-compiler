//
//  Log.swift
//  ModelCompiler
//
//  Created by Jeorge Taflanidy on 20/03/2017.
//  Copyright © 2017 RedMadRobot LLC. All rights reserved.
//

import Foundation


/**
 Override to forward logs somewhere else than ```stdout```
 */
open class Log {
    
    /**
     Verbose print to ```stdout```
     */
    open class func v(_ message: String) {
        print(message)
    }
    
}
