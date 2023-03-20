import Foundation

class NoteService {
    static let shared = NoteService()
    
    private var notes: [Note] = []
    
    private init() {
        loadNotes()
    }
    
    private func loadNotes() {
        guard let data = UserDefaults.standard.data(forKey: "notes"),
              let savedNotes = try? JSONDecoder().decode([Note].self, from: data) else {
            return
        }
        notes = savedNotes
    }
    
    private func saveNotes() {
        guard let data = try? JSONEncoder().encode(notes) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "notes")
    }
    
    func add(note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func remove(note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else {
            return
        }
        notes.remove(at: index)
        saveNotes()
    }
    
    func update(note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else {
            return
        }
        notes[index] = note
        saveNotes()
    }
    
    func getNotes() -> [Note] {
        return notes
    }
}
