import Foundation

struct Toy: Codable {
    var name: String
}

struct Employee: Codable {
    var name: String
    var id: Int
    var favoriteToy: Toy
}

let toy = Toy(name: "Teddy Bear")
let employee = Employee(name: "John Appleseed", id: 7, favoriteToy: toy)

let encoder = JSONEncoder()
let decoder = JSONDecoder()

let data = try encoder.encode(employee)
let string = String(data: data, encoding: .utf8)
print(string!)

let sameEmplotee = try decoder.decode(Employee.self, from: data)
