# My First Backend Project - FireCards

FireCards is a flashcard application built with SwiftUI and Firebase that helps users memorize information through digital flashcards. Users can create, view, and mark cards as memorized, with all data synchronized to Firebase in real-time.

## Features

- **User Authentication**: Sign up and log in with email and password
- **Create Flashcards**: Add new cards with questions and answers
- **Review System**: Mark cards as memorized when you've learned them
- **Real-time Updates**: Changes sync instantly across devices

## Screenshots

![image](https://github.com/user-attachments/assets/9e01af3f-eec4-4789-8941-d56ce7a7b9d2)

## Technologies Used

- **SwiftUI**: For building the user interface
- **Firebase Authentication**: For user management
- **Cloud Firestore**: For storing and syncing flashcard data

## Project Structure

The app follows a simple MVVM-inspired architecture:

- **Models**: `Card.swift` defines the data structure for flashcards
- **Views**: UI components like `ContentView`, `CardDetailView`, and `AddCardView`
- **Repository**: `CardRepository` handles all Firestore operations

## Implementation Details

### Firebase Integration

The app initializes Firebase in the main app file:

```swift
// FireCardsApp.swift
init() {
    FirebaseApp.configure()
}
```

## Challenges and Solutions
### 1. Bundle ID Mismatch
One of the most frustrating issues I encountered was a subtle mismatch between bundle identifiers:

**Problem:**
The Firebase configuration in GoogleService-Info.plist had a different bundle ID than what was set in my Xcode project:

```xml
// In GoogleService-Info.plist
<key>BUNDLE_ID</key>
<string>com.ys5298.FireCards</string>

// In Xcode project settings
Bundle Identifier: com.ys5289.FireCards
```

This tiny difference (5298 vs 5289) prevented Firebase from connecting properly, but the error messages weren't clear about the cause.

**Solution:**
I carefully compared the bundle IDs and updated the project settings to match the Firebase configuration:

```swift
// In Xcode:
// Project > Target > General > Bundle Identifier
// Changed from com.ys5289.FireCards to com.ys5298.FireCards
```

### 2. Missing Firebase Dependencies
**Problem:**
Initially, the app would crash with cryptic errors because I hadn't properly set up all the required Firebase dependencies.

**Solution:**
I added all necessary Firebase packages to my project using Swift Package Manager:

```swift
// In Xcode:
// File > Add Packages...
// Added:
// - firebase-ios-sdk (https://github.com/firebase/firebase-ios-sdk.git)
// Selected the following products:
// - FirebaseAuth
// - FirebaseFirestore
// - FirebaseFirestoreSwift
```


### 3. Firestore Document ID Handling
**Problem:**
When fetching cards from Firestore, I initially lost the document IDs, which made updating cards impossible:

```swift
self.cards = documents.compactMap { document -> Card? in
    return Card.from(dictionary: document.data())
}
```

**Solution:**
I modified the code to preserve the document ID:

```swift
self.cards = documents.compactMap { document -> Card? in
    let data = document.data()
    var card = Card.from(dictionary: data)
    card?.id = document.documentID
    return card
}
```

## Future Improvements
- Add categories for organizing cards
- Implement spaced repetition algorithm
- Add support for images in flashcards
- Create statistics to track learning progress
