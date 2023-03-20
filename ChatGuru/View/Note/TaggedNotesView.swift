import SwiftUI

struct TaggedNotesView: View {
    let tag: Tag
    @ObservedObject var noteManager: NoteManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(tag.name)
                .font(.headline)
            
            if noteManager.taggedNotes.isEmpty {
                Text("No notes for this tag yet.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(noteManager) { taggedNote in
                    NavigationLink(destination: NoteView(note: taggedNote.note)) {
                        TaggedNoteCellView(taggedNote: taggedNote)
                    }
                }
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add Note") {
                    // TODO: Implement adding new note
                }
            }
        }
        .onAppear {
            taggedNoteManager.loadTaggedNotes(for: tag)
        }
    }
}
