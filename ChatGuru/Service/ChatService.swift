import Foundation
import Alamofire

class ChatService: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private let baseUrl = "https://api.openai.com/v1/"
    private let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Authorization": "Bearer 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"
    ]
    
    func sendMessage(_ message: String) {
        
        let origninalMessage = ChatMessage(text: message, timestamp: Date(), sender: Sender(id: "Me", name: "Gurvineet"), isMe: true)
        self.messages.append(origninalMessage)
        
        let endpoint = "completions"
        let url = "\(baseUrl)\(endpoint)"
        let prompt = """
        \(message)
        """
        let parameters: [String: Any] = [
            "prompt": prompt,
            "max_tokens": 60,
            "n": 1,
            "stop": ".",
            "temperature": 0.7,
            "frequency_penalty": 0.5,
            "presence_penalty": 0.5,
            "model": "text-davinci-003"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: AIResponse.self) { response in
            switch response.result {
            case .success(let aiResponse):
                if let choice = aiResponse.choices.first {
                    
                    let chatMessage = ChatMessage(text: choice.text, timestamp: Date(), sender: Sender(id: "AI", name: "Murphy"), isMe: false)
                    self.messages.append(chatMessage)
//                    completion(.success(chatMessage))
                } else {
//                    completion(.failure(NSError(domain: "Response error", code: 0, userInfo: nil)))
                }
            case .failure(let error):
                print(error)
                break
//                completion(.failure(error))
            }
        }
    }
}


enum NetworkError: Error {
    case invalidURL
    case encodingFailed
    case decodingFailed
    case invalidData
    case invalidResponse
    case unknownError
}

struct AIRequest: Encodable {
    let prompt: String
    let temperature: Double
    let maxTokens: Int
    let apiKey: String
    let promptPrefix: String
    
    enum CodingKeys: String, CodingKey {
        case prompt
        case temperature
        case maxTokens = "max_tokens"
        case apiKey = "api_key"
        case promptPrefix = "prompt_prefix"
    }
}

struct AIResponse: Decodable {
    let choices: [AIChoice]
}

struct AIChoice: Decodable {
    let text: String
}

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

struct Sender: Codable {
    let id: String
    let name: String
}

       
