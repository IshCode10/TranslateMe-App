import SwiftUI

struct HistoryView: View {
    @State private var history: [Translation] = []
    
    var body: some View {
        VStack {
            if history.isEmpty {
                Text("No history available")
                    .padding()
            } else {
                List(history) { translation in
                    VStack(alignment: .leading) {
                        Text("Original: \(translation.original)")
                            .fontWeight(.bold)
                        Text("Translated: \(translation.translated)")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Button(action: clearHistory) {
                Text("Clear History")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear(perform: fetchHistory)
        .navigationTitle("Translation History")
    }
    
    private func fetchHistory() {
        FirestoreManager.shared.fetchHistory { result in
            switch result {
            case .success(let translations):
                history = translations
            case .failure(let error):
                print("Error fetching history: \(error)")
            }
        }
    }
    
    private func clearHistory() {
        FirestoreManager.shared.clearHistory {
            history.removeAll()
        }
    }
}
