# Model Compiler Framework

Framework scan your Swift code to get source code info.

**Recognize:**

* Classes (see `Klass`), protocols (see `Protokol`) with properties:
    - Name
    - Parent Class
    - Annotations (see `Annotation`, for annotations format see below)
    - Properties (see `Property`)
        - Name
        - Type (see `Typê`, supported types listed below)
        - Annotations (see `Annotation`)
        - Property Type (`var/let`, see `Property.constant`)
        - Nullability (see `Property.mandatory`)
    - Class Methods (see `Method`)
        + Name
        + Annotations (see `Annotation`)
        + Return Type (see `Typê`)
        + Method body (see `SourceCodeLine`)
        + Arguments (see `Argument`)
            * Name
            * Internal Name
            * Type `Typê`
            * Nullability 
            * Annotations (see `Annotation`)

**Every** model class (`Annotation, Argument, Klass, Method, Property, Typê, Protokol, SourceCodeFile, SourceCodeLine`) support `==` operator (protocol `Equatable`) and property `description` (protocol `CustomStringConvertible`).

## Setup

#### Git Submodule:

`git@github.com:RedMadRobot/model-compiler.git`

## Usage:

Entry point for using framework — `Compiler` class.

`Compiler` class gives you initializer with `verbose` argument (`Bool` type):

```Swift
let compiler = Compiler(verbose: true)
```

`verbose` argument enables debug mode, so you can check check successfully recognized models in warnings with readable description.

`Compiler` uses `SourceCodeFile` models as input. Every instance of `SourceCodeFile` should include **full** path `filename` and source code `lines`.

Source code line (`SourceCodeLine`) is object and has **full** path `filename`, line number (`lineNumber`) and source line (`line`).


Source code files converts into `String` objects and then to `SourceCodeFile`:

```Swift
let file = SourceCodeFile(filename: "Account.swift", contents: "...")
```

While compiler parse sources it can throw exception `CompilerMessage`. It just `print(compilerMessage)` and message will be displayed in Xcode issue navigator. 

```Swift
do {
    return try Compiler(verbose: debugMode).compile(file: code)
} catch let error as CompilerMessage {
    print(error)
} catch {
    // nothing to do
}
```

## Syntax

Framework will ignore specific file if it contains `@ignore` annotation in any place. See below more about annotations.

```Swift
/** 

 Next you can see source code that describes supported syntax 
 for current framework version.
 
 There are several rules, that compiler follows, and you need 
 to follow them.
 
 1. Source code shouldn't include unnecessary spaces 
  and empty lines. Compiler separate words by spaces and 
  new line symbols.
  For example JSONParser<Model> is one word for compiler.

 2. Compiler works with strings. If variable and its type are 
  on different lines – that type won't be recognized.
 
 3. Declarations should be on different lines, 
  for instance function name and its arguments. 
 
 4. Implicit type for variables is better.
 
 5. Compiler works with words class, protocol,
 var, let, func и init, and braces {}, (), [], colons
 and arrow ->.

 It's recommended to use current syntax for braces 
 in classes, methods and others.

 */

/**
 
 Entities should be declared in separate files. 
 Entity can be class or protocol (keyword class or protocol).
 
 Compiler ignores access control keywords.
 
 Compiler consider parent by having colon in declaration line. 
 If a class inherits another class and conforms to some protocols,
 parent is first word after colon.

 Class content begins with {
 This brace can be on the same line with class declaration.

 If { is inside block comment /** ... */, it'll be ignored.

 Class content ends with }
 This curly brace also should be outside block comment /** .. */
	
 Compiler uses scope restricted by curly braces. 
 If compiler meets {, current scope is incremented.
 If compiler meets }, current scope is decremented.

 Any deep scope is considered as function body and other syntax parts.
 Keywords var, let, func and others are ignored for this scope.

 @documentation omg!
 */
public class Entity: CoreDAO.Entity {

   /**
    KLASS
    name = Entity
    parent = CoreDAO.Entity
    annotations = [
       { name = documentation; value = omg! }
    ]
    */

   /**
    Entity Identifier.
    @json id
    */
    var id: Int 

   /**
    PROPERTY
    name = id
    type = .IntType
    mandatory = true
    constant = false
    annotations = [
        { name = json; value = id }
    ]
    */

   /**
    Entity name.
    */
    let name = "Entity"

   /**
    PROPERTY
    name = name
    type = .StringType
    mandatory = true
    constant = true
    annotations = []
    */ 

   /**
    Entity property with getter and setter.
    Curly braces syntax is the same as for functions.
    @sleep
    */
    var creationDate: Date?
    {
        get {
            return nil
        }
        set(newDate) {
            // nothing
        }
    }

   /**
    PROPERTY
    name = creationDate
    type = .DateType
    mandatory = false
    constant = false
    annotations = [
        { name = sleep; value = nil }
    ]
    */ 

   /**
    Initializer.
    */ 
    override init(
        id entityId: Int, // @id
        creationDate: Date?
    )
    {
        self.creationDate = creationDate
        self.id = entityId
        super.init(id: entityId, creationDate: creationDate)
    }

   /**
    METHOD
    name = "init"
    returnType = .ObjectType("Self")
    annotations = []
    arguments = [
        ARGUMENT {
            name = id
            bodyName = entityId
            type = .IntType
            mandatory = true
            annotations = [{ name = id; value = nil }]
        }
        ARGUMENT {
            name = creationDate
            bodyName = creationDate
            type = .DateType
            mandatory = false
            annotations = []
        }
    ]
    */ 

}

```

## Supported Types `Typê`

Next types are supported:

```Swift
.BoolType
.IntType
.FloatType
.DoubleType
.StringType
```

Also next collections and objects are supported:

```Swift
.DateType                          // variable: Date()
.DataType                          // variable: Data()
.ObjectType(name: String)          // variable: Name()
.ArrayType(item: Typê)             // variable: [Item]()
.MapType(pair: (key, value: Typê)) // variable: [Key:Value]
```

Enum `Typê` conforms protocol `CustomStringConvertible`:

```Swift
let type: Typê = ...
let message: String = "Type is \(type)"

.BoolType           => "Bool"
.IntType            => "Int"
.FloatType          => "Float"
.DoubleType         => "Double"
.StringType         => "String"
.DateType           => "Date"
.DataType           => "Data"
.ObjectType(Name)   => "Name"
.ArrayType(Item)    => "[Item]"
.MapType(pair)      => "[pair.key : pair.value]"
```

## Annotation format

Annotations for members are inside comments.

Compiler can recognize annotations from inline comments `// text` and block comments:

```Swift
/**
 Name.
 */
 var name: String
```

Other syntax is not supported. 

**Important!** Nearest from the top comment will be applied for any element in source code without documentation.

```Swift
/**
  This comment will be applied for propertyOne И propertyTwo.
 */
 var propertyOne: Int = 1

 let propertyTwo: String = "ABC"
```

**Annotations will be recognized** by symbol `@` in comment: 

```Swift
/**
 @ignore
 @name Operator
 */
```

Every annotation should inclide name, and optional value. Name and value can't include spaces and new line symbols.

Above you can see annotations `ignore` and `name`, symbol `@` is not included in annotation name. 

**For function atguments** are limitations: annotations should be inside inline comment for argument and arguments should be on different lines. 
If you need several annotations in one line, it's recommended to use format `@annotation value` with non-optional value.

Correct syntax:

**I**

```Swift
public override init(
    name: String, // @json name
    familyName: String // @json family_name @mandatory _
)
```

**II**

```Swift
public func make(firstName name: String, // @json
    lastName familyName: String // @json
)
```
