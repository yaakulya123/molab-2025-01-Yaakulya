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
    // Persistent storage for the registered username, profile color, and avatar.
    @AppStorage("registeredUsername") var registeredUsername: String = ""
    @AppStorage("profileColor") var profileColor: String = "Blue"
    @AppStorage("avatar") var avatar: String = "person.circle"
    
    // Local state for current session.
    @State private var isLoggedIn: Bool = false
    @State private var displayUsername: String = "Anonymous!"
    @State private var showLoginSheet: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // Display avatar if logged in
                if isLoggedIn {
                    Image(systemName: avatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(colorFromName(profileColor))
                        .transition(.scale)
                        .animation(.easeInOut, value: avatar)
                }
                
                // Welcome text uses profile color when logged in, black otherwise.
                Text("Welcome, \(displayUsername)")
                    .font(.largeTitle)
                    .foregroundColor(isLoggedIn ? colorFromName(profileColor) : .black)
                    .transition(.opacity)
                    .animation(.easeInOut, value: isLoggedIn)
                
                if isLoggedIn {
                    // Navigation link to the editable profile screen.
                    NavigationLink(destination: ProfileSettingsView()) {
                        Text("Edit Profile")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        withAnimation {
                            isLoggedIn = false
                            displayUsername = "Anonymous!"
                        }
                    }) {
                        Text("Logout")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                } else {
                    Button(action: {
                        withAnimation {
                            showLoginSheet = true
                        }
                    }) {
                        Text("Login")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Account Demo")
            // Present the login sheet for entering username, profile color, and avatar.
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
    @AppStorage("avatar") var avatar: String = "person.circle"
    
    // Bindings to update ContentView’s state.
    @Binding var isLoggedIn: Bool
    @Binding var displayUsername: String
    
    // Local state for user input.
    @State private var usernameInput: String = ""
    @State private var selectedColor: String = "Blue"
    @State private var selectedAvatar: String = "person.circle"
    
    let colorOptions = ["Blue", "Red", "Green", "Orange", "Purple"]
    let avatarOptions = ["person.circle", "person.crop.circle", "person.fill", "person.crop.square"]
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                    
                    Text("Select Avatar")
                        .font(.subheadline)
                    
                    Picker("Avatar", selection: $selectedAvatar) {
                        ForEach(avatarOptions, id: \.self) { option in
                            HStack {
                                Image(systemName: option)
                                Text(option)
                            }
                            .tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                    
                    Button("Submit") {
                        // Save username, profile color, and avatar.
                        if registeredUsername != usernameInput || registeredUsername.isEmpty {
                            registeredUsername = usernameInput
                        }
                        profileColor = selectedColor
                        avatar = selectedAvatar
                        
                        displayUsername = usernameInput
                        withAnimation {
                            isLoggedIn = true
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            }
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
    @AppStorage("avatar") var avatar: String = "person.circle"
    
    // Local state for editing.
    @State private var usernameInput: String = ""
    @State private var selectedColor: String = "Blue"
    @State private var selectedAvatar: String = "person.circle"
    
    let colorOptions = ["Blue", "Red", "Green", "Orange", "Purple"]
    let avatarOptions = ["person.circle", "person.crop.circle", "person.fill", "person.crop.square"]
    
    var body: some View {
        ScrollView {
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
                
                Text("Select Avatar")
                    .font(.subheadline)
                
                Picker("Avatar", selection: $selectedAvatar) {
                    ForEach(avatarOptions, id: \.self) { option in
                        HStack {
                            Image(systemName: option)
                            Text(option)
                        }
                        .tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                
                Button("Save") {
                    // Update persistent storage with new values.
                    registeredUsername = usernameInput
                    profileColor = selectedColor
                    avatar = selectedAvatar
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .onAppear {
                // Load current values.
                usernameInput = registeredUsername
                selectedColor = profileColor
                selectedAvatar = avatar
            }
        }
        .navigationTitle("Edit Profile")
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
    @State static var displayName = "Anonymous!"
    
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
