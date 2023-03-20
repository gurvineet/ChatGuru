import Foundation

class ChatPersistence {
    static let shared = ChatPersistence()

    private let chatMessagesURL: URL
    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.chatMessagesURL = documentsDirectory.appendingPathComponent("chatMessages.json")
    }

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func saveMessages(_ messages: [ChatMessage]) {
        do {
            let data = try encoder.encode(messages)
            try data.write(to: chatMessagesURL)
        } catch {
            print("Error saving chat messages: \(error.localizedDescription)")
        }
    }

    func loadMessages() -> [ChatMessage] {
        do {
            let data = try Data(contentsOf: chatMessagesURL)
            let messages = try decoder.decode([ChatMessage].self, from: data)
            return messages
        } catch {
            print("Error loading chat messages: \(error.localizedDescription)")
            return []
        }
    }
}
