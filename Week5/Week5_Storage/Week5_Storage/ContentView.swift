//
//  ContentView.swift
//  Week5_Storage
//
//  Created by Yaakulya Sabbani on 04/03/2025.
//

import SwiftUI

// Helper: Converts a profile color name (String) into a SwiftUI Color.
func colorFromName(_ name: String) -> Color {
    switch name {
    case "Red": return .red
    case "Green": return .green
    case "Orange": return .orange
    case "Purple": return .purple
    default: return .blue
    }
}

struct ContentView: View {
    // Persistent storage for the registered username and profile color.
    @AppStorage("registeredUsername") var registeredUsername: String = ""
    @AppStorage("profileColor") var profileColor: String = "Blue"
    
    // Local state for current session.
    @State private var isLoggedIn: Bool = false
    @State private var displayUsername: String = "Anonymous"
    @State private var showLoginSheet: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // When logged in, use the stored profile color; when logged out, show in black.
                Text("Welcome, \(displayUsername)")
                    .font(.largeTitle)
                    .foregroundColor(isLoggedIn ? colorFromName(profileColor) : .black)
                
                if isLoggedIn {
                    // Navigation link to the editable profile screen.
                    NavigationLink(destination: ProfileSettingsView()) {
                        Text("Edit Profile")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    Button("Logout") {
                        isLoggedIn = false
                        displayUsername = "Anonymous"
                    }
                    .padding()
                } else {
                    Button("Login") {
                        showLoginSheet = true
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Account Demo")
            // Present the login sheet for entering username and selecting profile color.
            .sheet(isPresented: $showLoginSheet) {
                LoginView(isLoggedIn: $isLoggedIn,
                          displayUsername: $displayUsername)
            }
        }
    }
}

// MARK: - LoginView
struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Access persistent storage.
    @AppStorage("registeredUsername") var registeredUsername: String = ""
    @AppStorage("profileColor") var profileColor: String = "Blue"
    
    // Bindings to update ContentView’s state.
    @Binding var isLoggedIn: Bool
    @Binding var displayUsername: String
    
    // Local state for user input.
    @State private var usernameInput: String = ""
    @State private var selectedColor: String = "Blue"
    
    let colorOptions = ["Blue", "Red", "Green", "Orange", "Purple"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Enter your username")
                    .font(.headline)
                
                TextField("Username", text: $usernameInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Text("Select Profile Color")
                    .font(.subheadline)
                
                Picker("Profile Color", selection: $selectedColor) {
                    ForEach(colorOptions, id: \.self) { color in
                        Text(color)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                Button("Submit") {
                    // Save username and profile color.
                    if registeredUsername != usernameInput || registeredUsername.isEmpty {
                        registeredUsername = usernameInput
                    }
                    profileColor = selectedColor
                    
                    displayUsername = usernameInput
                    isLoggedIn = true
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Login")
        }
    }
}

// MARK: - ProfileSettingsView (Editable Profile Screen)
struct ProfileSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Use the same persistent storage keys.
    @AppStorage("registeredUsername") var registeredUsername: String = ""
    @AppStorage("profileColor") var profileColor: String = "Blue"
    
    // Local state for editing.
    @State private var usernameInput: String = ""
    @State private var selectedColor: String = "Blue"
    
    let colorOptions = ["Blue", "Red", "Green", "Orange", "Purple"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Profile")
                .font(.largeTitle)
            
            TextField("Username", text: $usernameInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Text("Select Profile Color")
                .font(.subheadline)
            
            Picker("Profile Color", selection: $selectedColor) {
                ForEach(colorOptions, id: \.self) { color in
                    Text(color)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Button("Save") {
                // Update persistent storage with new values.
                registeredUsername = usernameInput
                profileColor = selectedColor
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .onAppear {
            // Load the current values.
            usernameInput = registeredUsername
            selectedColor = profileColor
        }
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var isLoggedIn = false
    @State static var displayName = "Anonymous"
    
    static var previews: some View {
        LoginView(isLoggedIn: $isLoggedIn,
                  displayUsername: $displayName)
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
