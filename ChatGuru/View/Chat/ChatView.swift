import SwiftUI

struct ChatView: View {
    @ObservedObject var chatManager = ChatManager()
    @ObservedObject var chatService = ChatService()
    @ObservedObject var noteManager = NoteManager(persistenceService: NotePersistenceService())
    @State var newMessageText = ""
    @State var selectedNote: Note?

    var body: some View {
        VStack {
            // Show notes list
            if !noteManager.notes.isEmpty {
            }
            NotesView(noteManager: noteManager)

            // Show chat messages
            ScrollView {
                LazyVStack {
                    ForEach(chatManager.chatMessages) { message in
                        ChatMessageView(message: message)
                    }
                }
            }

            // Input text field and send button
            HStack {
                TextField("Type message", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    // Send new message
                    let message = ChatMessage(text: newMessageText, sender: Sender(id: "AI", name: "AdamProbe"), isMe: true)
                    chatManager.addMessage(message)
                    chatService.sendMessage(message.text)

                    // Clear text field
                    newMessageText = ""

                    // Unselect note if one was selected
                    selectedNote = nil
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                })
                .padding()
            }
        }
        .navigationTitle("Chat")
        .onAppear {
            chatManager.loadMessages()
        }
        .onDisappear {
            chatManager.saveMessages()
        }
    }
}
