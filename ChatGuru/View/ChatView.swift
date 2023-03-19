import SwiftUI

struct ChatView: View {
    @StateObject private var chatService = ChatService()
    
    var body: some View {
        VStack(alignment: .center, spacing: .leastNormalMagnitude) {
            ScrollView {
                ForEach(chatService.messages) { message in
                    ChatMessageView(chatMessage: message)
                }
            }
            
            ChatInputView(chatService: chatService)
        }
    }
}

