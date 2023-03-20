import SwiftUI

struct NotesView: View {
    @ObservedObject var noteManager: NoteManager
    @State private var showingNoteEditView = false

    var body: some View {
        NavigationView {
            VStack {
                List(noteManager.notes) { note in
                    NavigationLink(destination: NoteView(note: note, noteManager: noteManager)) {
                        NoteRow(note: note)
                    }
                }
                .listStyle(InsetListStyle())
                .navigationTitle("Notes")
                
                HStack {
                    Spacer()
                    Button(action: {
                        showingNoteEditView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.secondary)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
            .sheet(isPresented: $showingNoteEditView) {
                NoteEditView(noteManager: noteManager)
            }
        }
    }
}

struct NoteRow: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.headline)
            Text(note.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
