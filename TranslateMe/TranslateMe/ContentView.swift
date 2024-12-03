import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var translatedText = ""
    @State private var showHistory = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter text to translate", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: translateText) {
                    Text("Translate")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(inputText.isEmpty)
                
                Text(translatedText.isEmpty ? "" : translatedText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .border(Color.gray)
                
                Spacer()
                
                Button(action: { showHistory = true }) {
                    Text("View History")
                        .padding()
                }
                
                NavigationLink("", destination: HistoryView(), isActive: $showHistory)
            }
            .padding()
            .navigationTitle("TranslationMe")
        }
    }
    
    private func translateText() {
        TranslationManager.shared.translate(text: inputText, from: "en", to: "es") { result in
            switch result {
            case .success(let translation):
                translatedText = translation
                FirestoreManager.shared.saveTranslation(original: inputText, translated: translation)
            case .failure(let error):
                print("Translation failed: \(error)")
            }
        }
    }
}
