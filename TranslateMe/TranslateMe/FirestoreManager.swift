import Firebase

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    func saveTranslation(original: String, translated: String) {
        let translation = Translation(original: original, translated: translated, timestamp: Date())
        do {
            try db.collection("translations").document().setData(from: translation)
        } catch {
            print("Error saving translation: \(error)")
        }
    }
    
    func fetchHistory(completion: @escaping (Result<[Translation], Error>) -> Void) {
        db.collection("translations").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let translations = snapshot?.documents.compactMap { document -> Translation? in
                try? document.data(as: Translation.self)
            } ?? []
            completion(.success(translations))
        }
    }
    
    func clearHistory(completion: @escaping () -> Void) {
        db.collection("translations").getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else { return }
            for document in snapshot.documents {
                document.reference.delete()
            }
            completion()
        }
    }
}
