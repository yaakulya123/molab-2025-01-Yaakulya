// AddCardView.swift
import SwiftUI

// View for adding a new flashcard
struct AddCardView: View {
    var cardRepository: CardRepository
    
    // State variables to track user input
    @State private var question: String = ""
    @State private var answer: String = ""
    // Environment variable to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                // Question input section
                Section(header: Text("Question")) {
                    TextField("Enter question", text: $question)
                }
                
                // Answer input section
                Section(header: Text("Answer")) {
                    TextField("Enter answer", text: $answer)
                }
                
                // Save button
                Button(action: saveCard) {
                    Text("Save Card")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                // Disable the button if either field is empty
                .disabled(question.isEmpty || answer.isEmpty)
                .listRowInsets(EdgeInsets())
                .padding()
            }
            .navigationTitle("Add New Card")
            .toolbar {
                // Cancel button to dismiss the view
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    // Function to save the new card to Firestore
    private func saveCard() {
        let newCard = Card(question: question, answer: answer)
        cardRepository.add(newCard)
        presentationMode.wrappedValue.dismiss()
    }
}