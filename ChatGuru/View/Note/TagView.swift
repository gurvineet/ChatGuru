import SwiftUI

struct TagView: View {
    let tag: Tag
    
    var body: some View {
        Text(tag.name)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(tag.color)
            .cornerRadius(4)
    }
}
