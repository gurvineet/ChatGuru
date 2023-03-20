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

struct Sender: Codable {
    let id: String
    let name: String
}

       
