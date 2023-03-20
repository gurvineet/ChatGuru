import SwiftUI

struct ChatMessageView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isMe {
                Spacer()
                Text(message.text)
                    .padding(12)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(16)
            } else {
                VStack(alignment: .leading) {
                    Text(message.sender.name)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    Text(message.text)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(Color.black)
                        .cornerRadius(16)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
