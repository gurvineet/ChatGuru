import Foundation

struct Tag: Codable, Equatable, Hashable {
    let id: UUID
    let name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    static func ==(lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

