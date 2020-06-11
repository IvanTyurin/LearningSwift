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

encoder.keyEncodingStrategy = .convertToSnakeCase
decoder.keyDecodingStrategy = .convertFromSnakeCase

let snakeData = try encoder.encode(employee)
let snakeString = String(data: snakeData, encoding: .utf8)!
let camelEmployee = try decoder.decode(Employee.self, from: snakeData)
print(camelEmployee)
