import Foundation
import PlaygroundSupport

// Function to load ASCII text from a file in the playground's Resources folder
func loadASCIIImage(named filename: String) -> String? {
    guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") else {
        return nil
    }
    return try? String(contentsOf: fileURL, encoding: .utf8)
}

// Function to display multiple ASCII images in a single column
func displayMultipleASCIIImages(filenames: [String]) {
    for filename in filenames {
        if let asciiArt = loadASCIIImage(named: filename) {
            let asciiLines = asciiArt.split(separator: "\n")
            for line in asciiLines {
                print(line)
            }
        } else {
            print("Failed to load ASCII image: \(filename)" )
        }
        print("") // Space between different images
    }
}

// Load and display the ASCII images in a single column
displayMultipleASCIIImages(filenames: ["cat", "bat", "elephant","batman"])
