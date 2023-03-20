import Foundation

struct ChatMessage: Identifiable, Hashable {
    let id: UUID
    let text: String
    let sender: Sender
    let timestamp: Date
    let isMe: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ChatMessage: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case senderId
        case senderName
        case timestamp
        case isMe
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        let senderId = try container.decode(String.self, forKey: .senderId)
        let senderName = try container.decode(String.self, forKey: .senderName)
        sender = Sender(id: senderId, name: senderName)
        
        let timestampString = try container.decode(String.self, forKey: .timestamp)
        if let timestamp = ISO8601DateFormatter().date(from: timestampString) {
            self.timestamp = timestamp
        } else {
            throw DecodingError.dataCorruptedError(forKey: .timestamp, in: container, debugDescription: "Invalid date format")
        }
        isMe = try container.decode(Bool.self, forKey: .isMe)
    }
}
