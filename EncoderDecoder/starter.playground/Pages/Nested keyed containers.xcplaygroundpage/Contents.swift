import Foundation

struct Toy: Codable {
    var name: String
}

struct Employee: Encodable {
    enum CodingKeys: CodingKey {
        case name, id, gift
    }

    enum GiftKeys: CodingKey {
        case toy
    }

    var name: String
    var id: Int
    var favoriteToy: Toy

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var giftContainer = container.nestedContainer(keyedBy: GiftKeys.self, forKey: .gift)

        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try giftContainer.encode(favoriteToy, forKey: .toy)
    }
}

let toy = Toy(name: "Teddy Bear")
let employee = Employee(name: "John Appleseed", id: 7, favoriteToy: toy)

let encoder = JSONEncoder()
let decoder = JSONDecoder()

let nestedData = try encoder.encode(employee)
let nestedString = String(data: nestedData, encoding: .utf8)!

extension Employee: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        let giftContainer = try container.nestedContainer(keyedBy: GiftKeys.self, forKey: .gift)
        favoriteToy = try giftContainer.decode(Toy.self, forKey: .toy)
    }
}

let sameEmployee = try decoder.decode(Employee.self, from: nestedData)
