// AuthenticationView.swift
import SwiftUI
import Firebase
import FirebaseAuth

// This view handles user authentication (login and signup)
struct AuthenticationView: View {
    // State variables to track user input and authentication status
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningUp = false  // Toggle between login and signup modes
    @State private var errorMessage = ""    // Display authentication errors
    @State private var isAuthenticated = false  // Track if user is logged in
    
    var body: some View {
        // If user is authenticated, show the main content
        if isAuthenticated {
            ContentView()
        } else {
            // Otherwise show the login/signup form
            NavigationView {
                Form {
                    // Email and password input fields
                    Section(header: Text("Login Information")) {
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Password", text: $password)
                    }
                    
                    // Display error messages if any
                    if !errorMessage.isEmpty {
                        Section {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Section {
                        // Login/Signup button
                        Button(isSigningUp ? "Sign Up" : "Log In") {
                            isSigningUp ? signUp() : logIn()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .listRowInsets(EdgeInsets())
                        
                        // Toggle between login and signup modes
                        Button(isSigningUp ? "Already have an account? Log In" : "Don't have an account? Sign Up") {
                            isSigningUp.toggle()
                            errorMessage = ""
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.blue)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .navigationTitle(isSigningUp ? "Sign Up" : "Log In")
            }
        }
    }
    
    // Function to handle user login with Firebase
    private func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isAuthenticated = true
            }
        }
    }
    
    // Function to handle user registration with Firebase
    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isAuthenticated = true
            }
        }
    }
}