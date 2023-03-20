import SwiftUI

struct NoteView: View {
    let note: Note
    @ObservedObject var noteManager: NoteManager
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(note.title)
                    .font(.title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Edit") {
                    NoteEditView(noteManager: noteManager, note: note)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            
            Text(note.content)
                .font(.body)
                .foregroundColor(.primary)
            
            Divider()
            
            HStack {
                ForEach(noteManager.taggedNotes.filter({$0.noteId == note.id})) { taggedNote in
                    if let actualtag = noteManager.tags.first(where: {$0.id == taggedNote.tagId}) {
                        TagView(tag: actualtag)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .padding()
        .navigationViewStyle(.automatic)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Delete") {
                    noteManager.deleteNote(note)
                }
            }
        }
    }
}

struct TagView: View {
    let tag: Tag
    
    var body: some View {
        Text(tag.name)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.primary)
            .cornerRadius(4)
    }
}

