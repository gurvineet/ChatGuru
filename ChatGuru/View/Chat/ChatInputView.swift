import SwiftUI

struct ChatInputView: View {
    @State private var text = ""
    var onSend: (String) -> Void

    var body: some View {
        HStack {
            TextField("Type a message...", text: $text, onCommit: {
                self.send()
            })
            Button(action: {
                self.send()
            }) {
                Text("Send")
            }
            .disabled(text.isEmpty)
        }
        .padding()
    }

    private func send() {
        guard !text.isEmpty else {
            return
        }
        onSend(text)
        text = ""
    }
}
