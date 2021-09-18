import UIKit

// Basic data types and variables
// #1
func getMarkName(mark: Int) -> String {
    switch mark {
    case 1:
        return "Nedovoljan"
    case 2:
        return "Dovoljan"
    case 3:
        return "Dobar"
    case 4:
        return "Vrlo dobar"
    case 5:
        return "Odličan"
    default:
        return "Unknown"
    }
}

print(5, getMarkName(mark: 5))

// #2
print((1...20).filter { $0.isMultiple(of: 2) })

// #3
func getSum(n: Int) -> Int {
    return (1...n).reduce(0, +)
}

print(getSum(n: 5))

// #4
func getJoinedNames(names: [String]) -> String {
    return names.joined(separator: ", ")
}

print(getJoinedNames(names: ["Marko", "Ivan", "Luka", "Pero"]))

// #5
func printInt(a: Int?) {
    if let a = a {
        if a < 0 {
            print("a je manji od 0")
        } else if a > 0 {
            print("a je veći od 0")
        } else {
            print("a je jednak 0")
        }
    } else {
        print("a je prazan")
    }
}

printInt(a: nil)

// #6
let daysOfWeek = [
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturaday",
    7: "Sunday"
]

print(daysOfWeek[5] ?? "")

// #7
let daysOfWeek2 = [
    1: ("Ponedjeljak", "Monday"),
    2: ("Utorak", "Tuesday"),
    3: ("Srijeda", "Wednesday"),
    4: ("Četvrtak", "Thursday"),
    5: ("Petak", "Friday"),
    6: ("Subota", "Saturaday"),
    7: ("Nedjelja", "Sunday")
]

// #8
let names = ["Bruno", "Domagoj", "Ivan", "Saša", "Ivan #2", "Ivan #3"]
for (index, name) in names.enumerated() where index % 2 == 1 {
    print(name)
}

// Functions
// #1
func printGreeting(name: String) {
    print("Hello, \(name)!")
}

// #2
// accidentally done in advance

// #3
func concat(_ string1: String, _ string2: String, _ string3: String = "") -> String {
    return "\(string1)\(string2)\(string3)"
}

print(concat("Ajn", "Cvo", "Draj"))

// #4
func getIndex(of string: String, in array: [String]) -> Int? {
    for index in 0..<array.count {
        if array[index] == string {
            return index
        }
    }
    
    return nil
}


// if an argument is named _, then its name isnt required when calling the funciton
// ie. someFunciton(arg)
// if an argument does have a nmes, its name is required when calling the function
// ie. someFunction(argumentName: argumentValue)

// a function with no return type returns Void

// unless its an inout argument, function arguments are always let

// Structures

struct ToDoList {
    var tasks = [ToDoTask]()
    
    mutating func remove(_ element: ToDoTask) {
        tasks.removeAll {
            $0 == element
        }
    }
    
    mutating func add(_ element: ToDoTask) {
        tasks.append(element)
    }
}

struct ToDoTask: Equatable{
    let task: String
    let dueDate: Date
    
    init(task: String, dueDate: Date = Date()) {
        self.task = task
        self.dueDate = dueDate
    }
    
    static func ==(lhs: ToDoTask, rhs: ToDoTask) -> Bool {
        return lhs.task == rhs.task && lhs.dueDate == rhs.dueDate
    }
}

let task1 = ToDoTask(task: "one")
let task2 = ToDoTask(task: "two")

var list = ToDoList()
list.add(task1)
list.add(task2)
print("Before:", list.tasks)
list.remove(task2)
print("After: ", list.tasks)

// Protocols

protocol Shape: {
    var surfaceArea: Float { get }
}


extension Shape {
    static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.surfaceArea < rhs.surfaceArea
    }
    
    static func <=(lhs: Self, rhs: Self) -> Bool {
        return lhs.surfaceArea <= rhs.surfaceArea
    }
    
    static func >(lhs: Self, rhs: Self) -> Bool {
        return lhs.surfaceArea > rhs.surfaceArea
    }
    
    static func >=(lhs: Self, rhs: Self) -> Bool {
        return lhs.surfaceArea >= rhs.surfaceArea
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.surfaceArea == rhs.surfaceArea
    }
    
    static func !=(lhs: Self, rhs: Self) -> Bool {
        return lhs.surfaceArea != rhs.surfaceArea
    }
    
    static func addAreas(shapes: [Self]) -> Float {
        var sum: Float = 0
        
        shapes.forEach {
            sum += $0.surfaceArea
        }
        
        return sum
    }
}

struct Circle: Shape {
    var surfaceArea: Float {
        return radius * radius * .pi
    }
    let radius: Float
}

struct Square: Shape {
    var surfaceArea: Float {
        return sideLength * sideLength
    }
    let sideLength: Float
}

struct Triangle: Equatable {
    let a: Float
    let b: Float
    let c: Float
    
    static func ==(lhs: Triangle, rhs: Triangle) -> Bool {
        return lhs.a == rhs.a && lhs.b == rhs.b && lhs.c == rhs.c
    }
}

extension Triangle: Shape {
    var surfaceArea: Float {
        return a*b*c // no the correct formula, should use Sarus' formula instead
    }
}





let c1 = Circle(radius: 1)
let c2 = Circle(radius: 2)
print(c1 > c2)


// Enumerations
// #1
enum ShapeType {
    case triangle(Float, Float, Float)
    case square(Float)
    case circle(Float)
}

// #2
func getShape(type: ShapeType) -> Shape {
    switch type {
    case .triangle:
        return Triangle(a: 1, b: 1, c: 1)
    case .square:
        return Square(sideLength: 1)
    case .circle:
        return Circle(radius: 1)
    }
}

// #3
func getAreaFrom(shape type: ShapeType) -> Float {
    switch type {
    case .triangle (let a, let b, let c):
        return Triangle(a: a, b: b, c: c).surfaceArea
    case .square (let sideLength):
        return Square(sideLength: sideLength).surfaceArea
    case .circle (let radius):
        return Circle(radius: radius).surfaceArea
    }
}

// raw values can be of any type

// Classes

class Database {
    var dictionary = [String: String]()
    
    func addRecord(key: String, value: String) {
        dictionary[key] = value
    }
    
    func removeValue(key: String) {
        dictionary.removeValue(forKey: key)
    }
}

class UserService {
    var database = Database()
    
    func register(username: String, password: String) {
        database.addRecord(key: username, value: password)
    }
    
    func login(username: String, password: String) -> Bool {
        return database.dictionary.contains { $0 == (username, password) }
    }
}

class NonMarinUserService: UserService {
    override func login(username: String, password: String) -> Bool {
        if username == "marin" {
            fatalError("Šta je Marin skrivio?")
        } else {
            return super.login(username: username, password: password)
        }
    }
}

// Higher-order functions
// #1
func parseToOptionalInts(array: [String]) -> [Int?] {
    return array.map { Int($0) }
}

// #2
func parseToInts(array: [String]) -> [Int] {
    return array.flatMap {
        if let number = Int($0) {
            return number
        } else {
            return 0
        }
    }
}

print(parseToInts(array: ["a", "z", "l"]))

// #3
func sumStringInts(array: [String]) -> Int {
    return array.reduce(0, { lastSum, current  in
        if let number = Int(current) {
            return lastSum + number
        }
        return lastSum
    })
}

print(sumStringInts(array: ["1", "2", "z"]))

// #4
func transform(string: String, onSuccess: (Int) -> Void) {
    if let number = Int(string) {
        onSuccess(number)
    }
}

transform(string: "5", onSuccess: { print("Succes! It's a \($0)!") })
