import SwiftUI

struct NoteListView: View {
    @ObservedObject var noteManager: NoteManager
    
    var body: some View {
        List {
            ForEach(noteManager.notes) { note in
                NavigationLink(destination: NoteView(note: note, noteManager: noteManager)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                            Text(note.content)
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                }
            }
//            .onDelete(perform: noteManager.deleteNote(noteManager.notes.first(where: { $0.id == note.id })
        }
        .navigationTitle("Notes")
//        .navigationDocument(url: NavigationLink(destination: NoteEditView(noteManager: noteManager)) {
//                Image(systemName: "plus")
//            }
//        )
//        .onAppear(perform: )
    }
}
