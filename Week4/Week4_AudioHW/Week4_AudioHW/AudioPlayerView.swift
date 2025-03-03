//
//  AudioPlayerView.swift
//  Week4_AudioHW
//
//  Created by jht2 on 3/2/25.
//

import SwiftUI
import AVFoundation

// Audio Player View
struct AudioPlayerView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    
    var body: some View {
        VStack {
            Text("Audio Player")
                .font(.largeTitle)
                .padding()
            
            Button(action: togglePlayback) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
        }
        .onAppear {
            loadAudio()
        }
    }
    
    func loadAudio() {
        if let path = Bundle.main.path(forResource: "audio", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        }
    }
    
    func togglePlayback() {
        if let player = audioPlayer {
            if player.isPlaying {
                player.pause()
                isPlaying = false
            } else {
                player.play()
                isPlaying = true
            }
        }
    }
}

