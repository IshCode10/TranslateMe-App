import Foundation

class TranslationManager {
    static let shared = TranslationManager()
    
    func translate(text: String, from sourceLang: String, to targetLang: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "https://api.mymemory.translated.net/get?q=\(text)&langpair=\(sourceLang)|\(targetLang)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(TranslationResponse.self, from: data)
                completion(.success(response.responseData.translatedText))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// Codable response model
struct TranslationResponse: Codable {
    struct ResponseData: Codable {
        let translatedText: String
    }
    let responseData: ResponseData
}
