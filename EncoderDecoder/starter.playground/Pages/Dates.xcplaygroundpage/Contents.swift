import Foundation

struct Toy: Codable {
  var name: String
}

let encoder = JSONEncoder()
let decoder = JSONDecoder()

struct Employee: Codable {
  var name: String
  var id: Int
  var birthday: Date
  var toy: Toy
}

let toy = Toy(name: "Teddy Bear")
let employee = Employee(name: "John Appleseed", id: 7, birthday: Date(), toy: toy)

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
    return formatter
    }()
}

encoder.dateEncodingStrategy = .formatted(.dateFormatter)
decoder.dateDecodingStrategy = .formatted(.dateFormatter)

let dateData = try encoder.encode(employee)
let dateString = String(data: dateData, encoding: .utf8)!
let sameEmployee = try decoder.decode(Employee.self, from: dateData)
