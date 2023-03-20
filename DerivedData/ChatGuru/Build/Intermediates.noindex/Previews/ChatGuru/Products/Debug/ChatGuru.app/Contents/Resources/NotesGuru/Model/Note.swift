import Foundation

struct Note: Identifiable {
    let id: UUID
    var title: String
    var content: String
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
    }
}

