// ContentView.swift
import SwiftUI
import Firebase
import FirebaseFirestore

// Main view that displays the list of flashcards
struct ContentView: View {
    // StateObject ensures the repository persists across view refreshes
    @StateObject var cardRepository = CardRepository()
    // State to control when to show the add card sheet
    @State private var showingAddCard = false
    
    var body: some View {
        NavigationView {
            List {
                // Create a row for each card in the repository
                ForEach(cardRepository.cards) { card in
                    CardRow(card: card, cardRepository: cardRepository)
                }
                // Enable swipe-to-delete functionality
                .onDelete { indexSet in
                    for index in indexSet {
                        cardRepository.delete(cardRepository.cards[index])
                    }
                }
            }
            .navigationTitle("FireCards")
            .toolbar {
                // Add button to create new cards
                Button(action: {
                    showingAddCard = true
                }) {
                    Image(systemName: "plus")
                }
            }
            // Show the add card view as a sheet when the add button is tapped
            .sheet(isPresented: $showingAddCard) {
                AddCardView(cardRepository: cardRepository)
            }
        }
    }
}

// View for displaying a single card in the list
struct CardRow: View {
    let card: Card
    let cardRepository: CardRepository
    @State private var showingDetail = false
    
    var body: some View {
        HStack {
            Text(card.question)
            Spacer()
            // Show a checkmark if the card is memorized
            if card.isMemorized {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .contentShape(Rectangle())
        // Show card details when tapped
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            CardDetailView(card: card, cardRepository: cardRepository)
        }
    }
}

// View for displaying and interacting with a single card's details
struct CardDetailView: View {
    var card: Card
    var cardRepository: CardRepository
    
    @State private var isShowingAnswer = false
    @State private var isMemorized: Bool
    @Environment(\.presentationMode) var presentationMode
    
    // Initialize the view with the card's current memorization status
    init(card: Card, cardRepository: CardRepository) {
        self.card = card
        self.cardRepository = cardRepository
        self._isMemorized = State(initialValue: card.isMemorized)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Question:")
                .font(.headline)
            
            // Display the question in a styled box
            Text(card.question)
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            
            // Button to toggle showing the answer
            Button(action: {
                isShowingAnswer.toggle()
            }) {
                Text(isShowingAnswer ? "Hide Answer" : "Show Answer")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            // Only show the answer section when the user taps the button
            if isShowingAnswer {
                Text("Answer:")
                    .font(.headline)
                    .padding(.top)
                
                // Display the answer in a styled box
                Text(card.answer)
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                
                // Toggle to mark the card as memorized
                Toggle("Memorized", isOn: $isMemorized)
                    .padding()
                    // Update the card in Firestore when the toggle changes
                    .onChange(of: isMemorized) { oldValue, newValue in
                        var updatedCard = card
                        updatedCard.isMemorized = newValue
                        updatedCard.lastReviewed = Date()
                        cardRepository.update(updatedCard)
                    }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Card Detail")
        .toolbar {
            Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
