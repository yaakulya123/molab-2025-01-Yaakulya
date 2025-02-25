//
//  ContentView.swift
//  Week4_AudioHW
//
//  Created by Yaakulya Sabbani on 25/02/2025.
//

import SwiftUI
import AVFoundation

struct Audio_AppApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView() // The main screen of the app
        }
    }
}

struct HomeView: View {
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Local Time Display
                    TimeDisplayView(title: "Local Time", time: FormattedTime(timeZone: .current))
                    
                    // Display World Clocks
                    VStack(spacing: 15) {
                        ForEach(worldClockData) { clock in
                            WorldClockView(city: clock.city, timeZone: clock.timeZone, currentTime: $currentTime)
                        }
                    }
                    
                    // Navigation to Audio Player
                    NavigationLink(destination: AudioPlayerView()) {
                        ButtonView(text: "Go to Audio Player", colors: [Color.red, Color.orange])
                    }
                }
            }
            .navigationTitle("World Clocks")
            .onReceive(timer) { _ in currentTime = Date() }
        }
    }
}

struct WorldClockView: View {
    var city: String
    var timeZone: String
    @Binding var currentTime: Date
    
    var body: some View {
        TimeDisplayView(title: city, time: FormattedTime(timeZone: TimeZone(identifier: timeZone)!))
    }
}

struct AudioPlayerView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            // Background Gradient for Audio Player
            LinearGradient(colors: [.blue.opacity(0.6), .purple.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Relax & Enjoy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Play/Pause Button
                Button(action: togglePlayback) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.blue.opacity(0.8)).frame(width: 120, height: 120))
                        .shadow(radius: 10)
                }
            }
        }
        .onAppear(perform: loadAudio)
    }
    
    func loadAudio() {
        // Load the audio file from the app bundle
        if let path = Bundle.main.path(forResource: "audio", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do { audioPlayer = try AVAudioPlayer(contentsOf: url) }
            catch { print("Error loading audio file: \(error.localizedDescription)") }
        }
    }
    
    func togglePlayback() {
        // Toggle between play and pause
        guard let player = audioPlayer else { return }
        isPlaying.toggle()
        
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
}

// A reusable component for displaying time
struct TimeDisplayView: View {
    var title: String
    var time: String
    
    var body: some View {
        Text("\(title): \(time)")
            .font(.title2)
            .foregroundColor(.white)
            .padding()
            .frame(width: 280)
            .background(Color.white.opacity(0.15))
            .cornerRadius(16)
            .shadow(radius: 3)
    }
}

// A reusable button component
struct ButtonView: View {
    var text: String
    var colors: [Color]
    
    var body: some View {
        Text(text)
            .font(.title2)
            .padding()
            .frame(width: 240)
            .background(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(radius: 5)
            .scaleEffect(1.05)
            .animation(.easeInOut(duration: 0.2), value: true)
    }
}

// Data model for world clocks
struct WorldClock: Identifiable {
    var id = UUID()
    var city: String
    var timeZone: String
}

// List of cities with their respective time zones
let worldClockData = [
    WorldClock(city: "New York", timeZone: "America/New_York"),
    WorldClock(city: "London", timeZone: "Europe/London"),
    WorldClock(city: "India", timeZone: "Asia/Kolkata"),
    WorldClock(city: "Australia", timeZone: "Australia/Sydney")
]

// Function to format time for different time zones
func FormattedTime(timeZone: TimeZone) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    formatter.timeZone = timeZone
    return formatter.string(from: Date())
}
