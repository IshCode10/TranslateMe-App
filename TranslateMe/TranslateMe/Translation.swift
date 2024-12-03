import Foundation
import FirebaseFirestore

struct Translation: Codable, Identifiable {
    @DocumentID var id: String?
    let original: String
    let translated: String
    let timestamp: Date
}
