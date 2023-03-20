import Foundation

struct Sender: Codable {
    let id: String
    let name: String
}

struct ChatMessage: Identifiable, Hashable, Codable {
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

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case sender
        case timestamp
        case isMe
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(sender, forKey: .sender)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(isMe, forKey: .isMe)
    }

    init(from aiResponse: AIResponse, sender: Sender) {
        let responseText = aiResponse.choices[0].text
        self.init(text: responseText, timestamp: Date(), sender: sender, isMe: false)
    }

    init(id: UUID = UUID(), text: String, timestamp: Date = Date(), sender: Sender, isMe: Bool = true) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.sender = sender
        self.isMe = isMe
    }
}

extension Array where Element == ChatMessage {
    func toData() -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(self)
    }

    static func fromData(_ data: Data) -> [ChatMessage]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode([ChatMessage].self, from: data)
    }
}

struct ChatMessageCodable: Codable {
    let text: String
    let timestamp: Date
    let senderID: String
    let senderName: String
    let isMe: Bool
    
    enum CodingKeys: String, CodingKey {
        case text
        case timestamp
        case senderID = "sender_id"
        case senderName = "sender_name"
        case isMe = "is_me"
    }
    
    init(chatMessage: ChatMessage) {
        self.text = chatMessage.text
        self.timestamp = chatMessage.timestamp
        self.senderID = chatMessage.sender.id
        self.senderName = chatMessage.sender.name
        self.isMe = chatMessage.isMe
    }
    
    func toChatMessage() -> ChatMessage {
        let sender = Sender(id: senderID, name: senderName)
        return ChatMessage(text: text, timestamp: timestamp, sender: sender, isMe: isMe)
    }
}
