//
//  CompilerTests.swift
//  ModelCompiler
//
//  Created by Egor Taflanidi on 30.03.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import XCTest
@testable import ModelCompiler

class CompilerTests: XCTestCase {
    
    fileprivate let TAB: String = "    "
    
    var compiler: Compiler!
    
    override func setUp() {
        super.setUp()
        self.compiler = Compiler(verbose: false)
    }
    
    override func tearDown() {
        self.compiler = nil
        super.tearDown()
    }
    
    func testCompile_stubSwiftKlassInput_equalsExpectedData() {
        let compiledKlass: Klass = try! self.compiler.compile(file:
            self.loadInput(nameOfFile: "Account.swift.test")
        )!
        
        XCTAssertEqual(compiledKlass, self.expectedKlass())
    }
    
    func testCompile_stubSwiftProtokolInput_equalsExpectedData() {
        let actualKlass: Klass = try! self.compiler.compile(file:
            self.loadInput(nameOfFile: "Protocol.swift.test")
        )!
        
        XCTAssertEqual(actualKlass, self.expectedProtokol())
    }
    
    func testCompile_basicProperties_equalsExpectedData() {
        let actualKlass: Klass = try! self.compiler.compile(file:
            self.loadInput(nameOfFile: "BasicPropertyTypes.swift.test")
        )!
        
        XCTAssertEqual(actualKlass, self.expectedBasicProperties())
    }
    
    func testCompile_simpleInitialiser_equalsExpectedData() {
        let actualKlass: Klass = try! self.compiler.compile(file:
            self.loadInput(nameOfFile: "SimpleInitialiser.swift.test")
        )!
        
        XCTAssertEqual(actualKlass, self.expectedSimpleInitialiser())
    }
    
    private func loadInput(nameOfFile: String) -> SourceCodeFile {
        var stubSwiftProtokolLines: [SourceCodeLine] = []
        
        for (index, line) in self.loadContentsOfFile(name: nameOfFile).lines().enumerated() {
            stubSwiftProtokolLines.append(
                SourceCodeLine(
                    absoluteFilePath: "",
                    lineNumber: index,
                    line: line
                )
            )
        }
        
        return SourceCodeFile(
            absoluteFilePath: "",
            lines: stubSwiftProtokolLines
        )
    }
    
    private func loadContentsOfFile(name: String) -> String {
        let path: String = Bundle(for: type(of: self)).path(forResource: name, ofType: nil, inDirectory: nil)!
        return try! String(contentsOfFile: path)
    }
    
    // MARK: - Тестовые данные
    
    func expectedKlass() -> Klass {
        return Klass(
            type: Klass.KlassType.klass,
            name: "Account",
            parents: ["Entity", "Identifiable"],
            properties: [
                    Property(
                        name: "name",
                        type: Typê.StringType,
                        annotations: [
                            Annotation(
                                name: "json",
                                value: "name"
                            ),
                            Annotation(
                                name: "mandatory",
                                value: nil
                            )
                        ],
                        constant: false,
                        declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 24, line: "    var name = String(\"name\")")
                    ),
                    Property(
                        name: "email",
                        type: Typê.ArrayType(
                            item: Typê.ObjectType(name: "Email")
                        ),
                        annotations: [
                            Annotation(
                                name: "json",
                                value: "email"
                            )
                        ],
                        constant: false,
                        declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 31, line: "    var email: [Email]")
                    ),
                    Property(
                        name: "identifier",
                        type: Typê.IntType,
                        annotations: [
                            Annotation(
                                name: "mandatory",
                                value: nil
                            ),
                            Annotation(
                                name: "json",
                                value: "id"
                            )
                        ],
                        constant: true,
                        declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 39, line: "    let identifier = 12345")
                    ),
                    Property(
                        name: "familyName",
                        type: Typê.StringType,
                        annotations: [],
                        constant: false,
                        declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 44, line: "    var familyName: String {")
                    ),
                    Property(
                        name: "variable",
                        type: Typê.OptionalType(wrapped: Typê.IntType),
                        annotations: [],
                        constant: false,
                        declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 57, line: "    var variable: Int64?")
                    )
            ],
            annotations: [
                Annotation(
                    name: "model",
                    value: "AccountModel"
                ),
                Annotation(
                    name: "json",
                    value: nil
                ),
                Annotation(
                    name: "realm",
                    value: "RLMAccount"
                ),
            ],
            declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 15, line: "class Account: Entity, Identifiable {"),
            methods: [
                ModelCompiler.Method(
                    name: "init",
                    arguments: [
                        Argument(
                            name: "name",
                            bodyName: "name",
                            type: .StringType,
                            annotations: [
                                Annotation(name: "cookie", value: nil)
                            ],
                            declaration: SourceCodeLine(
                                absoluteFilePath: "",
                                lineNumber: 64,
                                line: "name: String, // @cookie"
                            )
                        ),
                        Argument(
                            name: "email",
                            bodyName: "email",
                            type: .ArrayType(item: .ObjectType(name: "Email")),
                            annotations: [
                                Annotation(name: "fulfill", value: "Email")
                            ],
                            declaration: SourceCodeLine(
                                absoluteFilePath: "",
                                lineNumber: 65,
                                line: "email: [Email], // @fulfill Email"
                            )
                        ),
                        Argument(
                            name: "identifier",
                            bodyName: "identifier",
                            type: .IntType,
                            annotations: [
                                Annotation(name: "id", value: nil)
                            ],
                            declaration: SourceCodeLine(
                                absoluteFilePath: "",
                                lineNumber: 66,
                                line: "identifier: Int65 // @id"
                            )
                        )
                    ],
                    annotations: [
                        Annotation(name: "constructor", value: nil)
                    ],
                    returnType: .ObjectType(name: "Self"),
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 63, line: "    init("),
                    body: [
                        SourceCodeLine(absoluteFilePath: "", lineNumber: 67, line: "    ) {"),
                        SourceCodeLine(absoluteFilePath: "", lineNumber: 68, line: "        self.name = name"),
                        SourceCodeLine(absoluteFilePath: "", lineNumber: 69, line: "        self.email = email"),
                        SourceCodeLine(absoluteFilePath: "", lineNumber: 70, line: "        super.init(identifier: identifier)"),
                        SourceCodeLine(absoluteFilePath: "", lineNumber: 71, line: "    }")
                    ]
                )
            ],
            body: []
        )
    }
    
    func expectedProtokol() -> Klass {
        return Klass(
            type: Klass.KlassType.protokol,
            name: "Account",
            parents: ["Entity"],
            properties: [
                
            ],
            annotations: [
                Annotation(
                    name: "model",
                    value: nil
                ),
                Annotation(
                    name: "realm",
                    value: "RLMAccount"
                )
            ],
            declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 15, line: "protocol Account: Entity {"),
            methods: [
                
            ],
            body: []
        )
    }
    
    func expectedBasicProperties() -> Klass {
        return Klass(
            type: Klass.KlassType.klass,
            name: "BasicPropertyTypes",
            parents: [],
            properties: [
                Property(
                    name: "flag",
                    type: Typê.BoolType,
                    annotations: [],
                    constant: true,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 12, line: "    let flag: Bool")
                ),
                Property(
                    name: "flagOpt",
                    type: Typê.OptionalType(wrapped: Typê.BoolType),
                    annotations: [],
                    constant: false,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 17, line: "    var flagOpt: Bool?")
                ),
                Property(
                    name: "number",
                    type: Typê.IntType,
                    annotations: [],
                    constant: true,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 22, line: "    let number: Int16")
                ),
                Property(
                    name: "numberOpt",
                    type: Typê.OptionalType(wrapped: Typê.IntType),
                    annotations: [],
                    constant: false,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 27, line: "    var numberOpt: Int32?")
                ),
                Property(
                    name: "decimal",
                    type: Typê.DoubleType,
                    annotations: [],
                    constant: true,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 32, line: "    let decimal: Double")
                ),
                Property(
                    name: "decimalOpt",
                    type: Typê.OptionalType(wrapped: Typê.DoubleType),
                    annotations: [],
                    constant: false,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 37, line: "    var decimalOpt: Double?")
                ),
                Property(
                    name: "floating",
                    type: Typê.FloatType,
                    annotations: [],
                    constant: true,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 42, line: "    let floating: Float")
                ),
                Property(
                    name: "floatingOpt",
                    type: Typê.OptionalType(wrapped: Typê.FloatType),
                    annotations: [],
                    constant: false,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 47, line: "    var floatingOpt: Float?")
                ),
                Property(
                    name: "line",
                    type: Typê.StringType,
                    annotations: [],
                    constant: true,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 52, line: "    let line: String")
                ),
                Property(
                    name: "lineOpt",
                    type: Typê.OptionalType(wrapped: Typê.StringType),
                    annotations: [],
                    constant: false,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 57, line: "    var lineOpt: String?")
                ),
                Property(
                    name: "date",
                    type: Typê.DateType,
                    annotations: [],
                    constant: true,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 62, line: "    let date: Date")
                ),
            ],
            annotations: [],
            declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 5, line: "class BasicPropertyTypes {"),
            methods: [],
            body: []
        )
    }
    
    func expectedSimpleInitialiser() -> Klass {
        return Klass(
            type: Klass.KlassType.klass,
            name: "SimpleInitialiser",
            parents: [],
            properties: [
                Property(
                    name: "name",
                    type: Typê.StringType,
                    annotations: [],
                    constant: true,
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 10, line: "    let name: String")
                )
            ],
            annotations: [],
            declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 5, line: "class SimpleInitialiser {"),
            methods: [
                ModelCompiler.Method(
                    name: "init",
                    arguments: [Argument(name: "name", bodyName: "name", type: Typê.StringType, annotations: [], declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 15, line: "name: String"))],
                    annotations: [],
                    returnType: Typê.ObjectType(name: "Self"),
                    declaration: SourceCodeLine(absoluteFilePath: "", lineNumber: 15, line: "    init(name: String) {"),
                    body: [
                        SourceCodeLine(absoluteFilePath: "", lineNumber: 15, line: "    init(name: String) {"),
                        SourceCodeLine(absoluteFilePath: "", lineNumber: 16, line: "        self.name = name"),
                        SourceCodeLine(absoluteFilePath: "", lineNumber: 17, line: "    }"),
                    ]
                )
            ],
            body: []
        )
    }
    
}
