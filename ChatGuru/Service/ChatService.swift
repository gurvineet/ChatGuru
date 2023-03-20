import Foundation
import Alamofire

class ChatService: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private let baseUrl = "https://api.openai.com/v1/"
    private let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Authorization": "Bearer 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"
    ]
    
    private let fileManager = FileManager.default
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let chatMessagesURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("chatMessages.json")
    
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
                    print(chatMessage)
                }
            case .failure(let error):
                print(error)
            }
        }
        self.saveChatMessages()
    }
    
    private func saveChatMessages() {
        let chatMessages = messages.map { ChatMessageCodable(chatMessage: $0) }
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(chatMessages)
            try jsonData.write(to: chatMessagesURL)
        } catch {
            print("Error saving chat messages: \(error.localizedDescription)")
        }
    }
    
    private func loadChatMessages() -> [ChatMessage] {
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: chatMessagesURL)
            let chatMessages = try jsonDecoder.decode([ChatMessageCodable].self, from: jsonData)
            return chatMessages.map { $0.toChatMessage() }
        } catch {
            print("Error loading chat messages: \(error.localizedDescription)")
            return []
        }
    }
}
