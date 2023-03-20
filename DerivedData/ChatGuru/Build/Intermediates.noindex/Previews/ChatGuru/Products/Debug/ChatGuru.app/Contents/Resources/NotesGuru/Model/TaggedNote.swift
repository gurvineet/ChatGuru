import Foundation

struct TaggedNote: Identifiable {
    let id = UUID()
    let note: Note
    let tags: [Tag]
}

