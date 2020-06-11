import Foundation

struct Toy: Codable {
  var name: String
}
let toy = Toy(name: "Teddy Bear")
let encoder = JSONEncoder()
let decoder = JSONDecoder()


enum AnyEmployee: Encodable {
    enum CodingKeys: CodingKey {
        case name, id, birthday, toy
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
           case .defaultEmployee(let name, let id):
               try container.encode(name, forKey: .name)
               try container.encode(id, forKey: .id)
           case .customEmployee(let name, let id, let birthday, let toy):
               try container.encode(name, forKey: .name)
               try container.encode(id, forKey: .id)
               try container.encode(birthday, forKey: .birthday)
               try container.encode(toy, forKey: .toy)
           case .noEmployee:
               let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Invalid employee!")
               throw EncodingError.invalidValue(self, context)
           }
    }

    case defaultEmployee(String, Int)
    case customEmployee(String, Int, Date, Toy)
    case noEmployee


}
