import Foundation

struct TaggedNote: Identifiable, Codable {
    let id: UUID
    let noteId: UUID
    let tagId: UUID
    
    init(noteId: UUID, tagId: UUID) {
        self.id = UUID()
        self.noteId = noteId
        self.tagId = tagId
    }
}

