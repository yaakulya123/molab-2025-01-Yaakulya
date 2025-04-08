// FireCardsApp.swift
import SwiftUI
import Firebase

// @main attribute identifies the entry point of the app
@main
struct FireCardsApp: App {
    // Initialize Firebase when the app starts
    init() {
        FirebaseApp.configure()
    }
    
    // Define the app's scene structure
    var body: some Scene {
        WindowGroup {
            // Set AuthenticationView as the first screen users will see
            // This handles user login and registration
            AuthenticationView()
        }
    }
}
