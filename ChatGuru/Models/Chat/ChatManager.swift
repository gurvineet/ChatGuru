import Foundation

class ChatManager: ObservableObject {
    @Published var chatMessages: [ChatMessage] = []
    @Published var error: Error?

    func addMessage(_ message: ChatMessage) {
        chatMessages.append(message)
    }
    
    func removeMessage(at index: Int) {
        chatMessages.remove(at: index)
    }

    // Load chat messages from JSON file
    func loadMessages() {
        if let url = Bundle.main.url(forResource: "chatMessages", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let messages = try decoder.decode([ChatMessage].self, from: data)
                chatMessages = messages
            } catch {
                self.error = error
            }
        } else {
            self.error = NSError(domain: "ChatManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to locate chatMessages.json"])
        }
    }

    // Save chat messages to JSON file
    func saveMessages() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(chatMessages)
            try data.write(to: URL(fileURLWithPath: "chatMessages.json"))
        } catch {
            self.error = error
        }
    }
}
