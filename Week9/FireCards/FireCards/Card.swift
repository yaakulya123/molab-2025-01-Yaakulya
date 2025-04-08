// Card.swift
import Foundation
import FirebaseFirestore

// Card model representing a flashcard with question and answer
struct Card: Identifiable {
    var id: String = UUID().uuidString  // Unique identifier for each card
    var question: String                // The question on the front of the card
    var answer: String                  // The answer on the back of the card
    var isMemorized: Bool = false       // Whether the user has memorized this card
    var lastReviewed: Date = Date()     // When the card was last reviewed
    
    // Convert the Card to a dictionary for Firestore storage
    var dictionary: [String: Any] {
        return [
            "id": id,
            "question": question,
            "answer": answer,
            "isMemorized": isMemorized,
            "lastReviewed": Timestamp(date: lastReviewed)  // Convert Date to Firestore Timestamp
        ]
    }
}

// Extension to create a Card from a Firestore document
extension Card {
    static func from(dictionary: [String: Any]) -> Card? {
        // Extract fields from the dictionary, return nil if required fields are missing
        guard let id = dictionary["id"] as? String,
              let question = dictionary["question"] as? String,
              let answer = dictionary["answer"] as? String,
              let isMemorized = dictionary["isMemorized"] as? Bool else {
            return nil
        }
        
        // Create a new card with the extracted data
        var card = Card(
            id: id,
            question: question,
            answer: answer,
            isMemorized: isMemorized
        )
        
        // Set the lastReviewed date if available
        if let timestamp = dictionary["lastReviewed"] as? Timestamp {
            card.lastReviewed = timestamp.dateValue()
        }
        
        return card
    }
}