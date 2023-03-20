import SwiftUI

struct NoteEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var noteManager: NoteManager
    @State private var title: String
    @State private var content: String
    @State private var selectedTags: Set<Tag> = []
    private let note: Note?

    init(noteManager: NoteManager, note: Note? = nil) {
        self.noteManager = noteManager
        self.note = note
        _title = State(initialValue: note?.title ?? "")
        _content = State(initialValue: note?.content ?? "")
        let taggedNotes = noteManager.taggedNotes.filter { $0.noteId == note?.id }
        let tags = Set(taggedNotes.map { tag in noteManager.tags.first { $0.id == tag.tagId }! })
        _selectedTags = State(initialValue: tags)
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Divider()
            }

            VStack(alignment: .leading, spacing: 4) {
                TextEditor(text: $content)
                    .frame(minHeight: 200)
                    .border(Color.gray, width: 1)
                Divider()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Tags")
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(noteManager.tags, id: \.self) { tag in
                            TagButton(tag: tag, isSelected: selectedTags.contains(tag)) {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            }
                        }
                    }
                }
            }

            Button(action: saveNote) {
                Text(note != nil ? "Update Note" : "Add Note")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .disabled(title.isEmpty || content.isEmpty)

            Spacer()
        }
        .padding()
        .navigationTitle(note != nil ? "Edit Note" : "New Note")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .automatic) {
                Button("Delete") {
                    if let note = note {
                        noteManager.deleteNote(note)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(note == nil)
            }
        }
    }

    private func saveNote() {
        if var note = note {
            note.title = title
            note.content = content
            noteManager.updateNote(note)
        } else {
            let note = Note(title: title, content: content)
            noteManager.addNote(note)
            selectedTags.forEach { tag in
                noteManager.addTaggedNote(TaggedNote(noteId: note.id, tagId: tag.id))
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct TagButton: View {
    let tag: Tag
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag.name)
                .font(.system(size: 14))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(isSelected ? Color.blue : Color(.gray))
                .cornerRadius(15)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
