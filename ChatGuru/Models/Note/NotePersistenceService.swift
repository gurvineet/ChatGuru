import Foundation

class NotePersistenceService {
    private let notesFilename = "notes.json"
    private let tagsFilename = "tags.json"
    private let taggedNotesFilename = "taggedNotes.json"
    
    func saveNotes(_ notes: [Note]) {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: notesURL())
        } catch {
            print("Error saving notes: \(error.localizedDescription)")
        }
    }
    
    func fetchNotes() throws -> [Note] {
        let data = try Data(contentsOf: notesURL())
        return try JSONDecoder().decode([Note].self, from: data)
    }
    
    func saveTags(_ tags: [Tag]) {
        do {
            let data = try JSONEncoder().encode(tags)
            try data.write(to: tagsURL())
        } catch {
            print("Error saving tags: \(error.localizedDescription)")
        }
    }
    
    func fetchTags() throws -> [Tag] {
        let data = try Data(contentsOf: tagsURL())
        return try JSONDecoder().decode([Tag].self, from: data)
    }
    
    func saveTaggedNotes(_ taggedNotes: [TaggedNote]) {
        do {
            let data = try JSONEncoder().encode(taggedNotes)
            try data.write(to: taggedNotesURL())
        } catch {
            print("Error saving tagged notes: \(error.localizedDescription)")
        }
    }
    
    func fetchTaggedNotes() throws -> [TaggedNote] {
        let data = try Data(contentsOf: taggedNotesURL())
        return try JSONDecoder().decode([TaggedNote].self, from: data)
    }
    
    private func notesURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(notesFilename)
    }
    
    private func tagsURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(tagsFilename)
    }
    
    private func taggedNotesURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(taggedNotesFilename)
    }
}
