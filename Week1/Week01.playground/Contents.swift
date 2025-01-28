// Function to generate a wave pattern with emojis
func generateEmojiWave(rows: Int) {
    let emojis = ["🌊", "💧", "✨", "🔥", "🌟", "💥", "🍀"]
    
    for i in 0..<rows {
        let spaces = String(repeating: " ", count: i) // Add spaces to create the wave effect
        let emoji = emojis[i % emojis.count] // Cycle through emojis
        print("\(spaces)\(emoji)\(emoji)\(emoji)")
    }
}

// Call the function to create the wave
generateEmojiWave(rows: 10)
