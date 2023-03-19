import SwiftUI

struct ChatMessageView: View {
    let chatMessage: ChatMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: .ulpOfOne) {
            if !chatMessage.isMe {
                Image(systemName: "person.fill")
                    .foregroundColor(.secondary)
                    .font(.system(size: 24))
                    .padding(.leastNormalMagnitude)
            }
            
            VStack(alignment: chatMessage.isMe ? .trailing : .leading, spacing: .leastNormalMagnitude) {
                if !chatMessage.isMe {
                    Text(chatMessage.sender.name)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Text(chatMessage.text)
                    .padding(10)
                    .background(chatMessage.isMe ? Color.blue : Color.secondary)
                    .foregroundColor(chatMessage.isMe ? .white : .primary)
                    .cornerRadius(12)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(chatMessage.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if chatMessage.isMe {
                Image(systemName: "person.fill")
                    .foregroundColor(.primary)
                    .font(.system(size: 24))
                    .padding(.leastNormalMagnitude)
            }
        }
        #if os(macOS)
        .frame(maxWidth: .infinity, alignment: chatMessage.isMe ? .trailing : .leading)
        #endif
    }
}




extension ChatMessage {
    init(from aiResponse: AIResponse, sender: Sender) {
        let responseText = aiResponse.choices[0].text
        self.init(text: responseText, timestamp: Date(), sender: sender, isMe: false)
    }

    init(text: String, timestamp: Date = Date(), sender: Sender, isMe: Bool = true) {
        self.id = UUID()
        self.text = text
        self.timestamp = timestamp
        self.sender = sender
        self.isMe = isMe
    }
}
