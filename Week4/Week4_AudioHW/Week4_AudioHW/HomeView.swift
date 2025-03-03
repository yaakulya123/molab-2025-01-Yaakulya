//
//  ContentView.swift
//  Week4_AudioHW
//
//  Created by Yaakulya Sabbani on 25/02/2025.
//

import SwiftUI

// Main App Structure
//struct Audio_AppApp: App {
//    var body: some Scene {
//        WindowGroup {
//            HomeView()
//        }
//    }
//}

// Home Screen displaying real-time clock with Enhanced UI
struct HomeView: View {
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    VStack {
                        Text("Local Time")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text(FormattedTime(timeZone: .current))
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 280)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                    
                    VStack(spacing: 15) {
                        WorldClockView(city: "New York", timeZone: "America/New_York", currentTime: $currentTime)
                        WorldClockView(city: "London", timeZone: "Europe/London", currentTime: $currentTime)
                        WorldClockView(city: "India", timeZone: "Asia/Kolkata", currentTime: $currentTime)
                        WorldClockView(city: "Australia", timeZone: "Australia/Sydney", currentTime: $currentTime)
                    }
                    
                    NavigationLink(destination: AudioPlayerView()) {
                        Text("Go to Audio Player")
                            .font(.title2)
                            .padding()
                            .frame(width: 240)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(radius: 5)
                            .scaleEffect(1.05)
                            .animation(.easeInOut(duration: 0.2), value: true)
                    }
                }
            }
            .navigationTitle("World Clocks")
            .onReceive(timer) { _ in
                currentTime = Date()
            }
        }
    }
    
    func FormattedTime(timeZone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.timeZone = timeZone
        return formatter.string(from: currentTime)
    }
}

// Reusable World Clock Component
struct WorldClockView: View {
    var city: String
    var timeZone: String
    
    @Binding var currentTime: Date
    
    var body: some View {
        Text("\(city): " + FormattedTime(timeZone: TimeZone(identifier: timeZone)!))
            .font(.title2)
            .foregroundColor(.white)
            .padding()
            .frame(width: 280)
            .background(Color.white.opacity(0.15))
            .cornerRadius(16)
            .shadow(radius: 3)
    }
    
    func FormattedTime(timeZone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.timeZone = timeZone
        return formatter.string(from: currentTime)
    }
}

#Preview {
  HomeView()
}
