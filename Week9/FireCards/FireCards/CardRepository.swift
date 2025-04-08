// CardRepository.swift
import Foundation
import Firebase
import FirebaseFirestore

// Repository class to handle all Firestore operations for cards
class CardRepository: ObservableObject {
    // Published property that will notify views when it changes
    @Published var cards: [Card] = []
    
    // Reference to Firestore database
    private let db = Firestore.firestore()
    // Name of the collection in Firestore
    private let collectionName = "cards"
    
    // Initialize and fetch cards from Firestore
    init() {
        fetchCards()
    }
    
    // Fetch all cards from Firestore and listen for real-time updates
    func fetchCards() {
        db.collection(collectionName).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Convert Firestore documents to Card objects
            self.cards = documents.compactMap { document -> Card? in
                let data = document.data()
                var card = Card.from(dictionary: data)
                card?.id = document.documentID
                return card
            }
        }
    }
    
    // Add a new card to Firestore
    func add(_ card: Card) {
        var newCard = card
        if newCard.id.isEmpty {
            newCard.id = UUID().uuidString
        }
        
        do {
            // Set data in Firestore with the card's ID as the document ID
            _ = try db.collection(collectionName).document(newCard.id).setData(newCard.dictionary)
        } catch {
            print("Error adding card: \(error.localizedDescription)")
        }
    }
    
    // Update an existing card in Firestore
    func update(_ card: Card) {
        do {
            // Update the document with the same ID as the card
            _ = try db.collection(collectionName).document(card.id).setData(card.dictionary)
        } catch {
            print("Error updating card: \(error.localizedDescription)")
        }
    }
    
    // Delete a card from Firestore
    func delete(_ card: Card) {
        db.collection(collectionName).document(card.id).delete { error in
            if let error = error {
                print("Error removing card: \(error.localizedDescription)")
            }
        }
    }
}