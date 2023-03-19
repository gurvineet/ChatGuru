import SwiftUI

struct ChatInputView: View {
    @ObservedObject var chatService: ChatService
    @State private var messageText = ""

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            TextField("Message", text: $messageText)
                .padding(.horizontal)
            Button(action: sendMessage) {
                Text("Send")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding(.trailing)
        }
        .padding(.vertical)
        .background(Color(.clear))
    }
    
    private func sendMessage() {
        if !messageText.isEmpty {
            chatService.sendMessage(messageText)
            messageText = ""
        }
    }
}
