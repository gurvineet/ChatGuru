import Foundation

class NoteManager: ObservableObject {
    @Published var tags: [Tag] = []
    @Published var notes: [Note] = []
    @Published var taggedNotes: [TaggedNote] = []
    @Published var error: Error?
    
    private let persistenceService: NotePersistenceService
    
    init(persistenceService: NotePersistenceService) {
        self.persistenceService = persistenceService
        loadNotes()
        loadTags()
        loadTaggedNotes()
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        persistenceService.saveNotes(notes)
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            persistenceService.saveNotes(notes)
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll(where: { $0.id == note.id })
        taggedNotes.removeAll(where: { $0.noteId == note.id })
        persistenceService.saveNotes(notes)
        persistenceService.saveTaggedNotes(taggedNotes)
    }
    
    func addTag(_ tag: Tag) {
        tags.append(tag)
        persistenceService.saveTags(tags)
    }
    
    func updateTag(_ tag: Tag) {
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            tags[index] = tag
            persistenceService.saveTags(tags)
        }
    }
    
    func deleteTag(_ tag: Tag) {
        tags.removeAll(where: { $0.id == tag.id })
        taggedNotes.removeAll(where: { $0.tagId == tag.id })
        persistenceService.saveTags(tags)
        persistenceService.saveTaggedNotes(taggedNotes)
    }
    
    func addTaggedNote(_ taggedNote: TaggedNote) {
        taggedNotes.append(taggedNote)
        persistenceService.saveTaggedNotes(taggedNotes)
    }
    
    func deleteTaggedNotes(for note: Note) {
        taggedNotes.removeAll(where: { $0.noteId == note.id })
        persistenceService.saveTaggedNotes(taggedNotes)
    }
    
    func deleteTaggedNotes(for tag: Tag) {
        taggedNotes.removeAll(where: { $0.tagId == tag.id })
        persistenceService.saveTaggedNotes(taggedNotes)
    }
    
    private func loadNotes() {
        do {
            notes = try persistenceService.fetchNotes()
        } catch {
            self.error = error
        }
    }
    
    private func loadTags() {
        do {
            tags = try persistenceService.fetchTags()
        } catch {
            self.error = error
        }
    }
    
    private func loadTaggedNotes() {
        do {
            taggedNotes = try persistenceService.fetchTaggedNotes()
        } catch {
            self.error = error
        }
    }
}
