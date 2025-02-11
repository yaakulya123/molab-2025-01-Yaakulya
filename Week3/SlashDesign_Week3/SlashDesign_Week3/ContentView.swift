//
//  ContentView.swift
//  SlashDesign_Week3
//
//  Created by Yaakulya Sabbani on 11/02/2025.
//

import SwiftUI

struct ContentView: View {
    let animInterval = 0.10 // Update every tenth of a second
    let columns = 20
    let rows = 20
    let gridSize: CGFloat = 20 // Size of each cell

    @State private var paths: [Path] = [] // Store paths
    @State private var currentIndex = 0 // Track the number of drawn elements

    var body: some View {
        VStack {
            Text("Animated 10PRINT Slash Pattern")
                .font(.headline)
                .padding()

            // Canvas View with Animation
            Canvas { context, size in
                for path in paths {
                    let style = StrokeStyle(lineWidth: 2, lineCap: .round)
                    context.stroke(path, with: .color(.black), style: style)
                }
            }
            .frame(width: CGFloat(columns) * gridSize, height: CGFloat(rows) * gridSize)
            .background(Color.white)
            .border(Color.gray)
            .onAppear {
                generatePattern()
            }
            .onReceive(Timer.publish(every: animInterval, on: .main, in: .common).autoconnect()) { _ in
                updatePattern()
            }

            // Reset Button
            Button("Reset Pattern") {
                generatePattern()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }

    // Generate Initial Pattern (Only called on Reset)
    func generatePattern() {
        paths = []
        currentIndex = 0 // Reset tracking index
    }

    // Updates the pattern continuously until the grid is full
    func updatePattern() {
        if currentIndex >= columns * rows {
            return // Stop updating once the grid is full
        }

        let row = currentIndex / columns
        let col = currentIndex % columns
        let start = CGPoint(x: CGFloat(col) * gridSize, y: CGFloat(row) * gridSize)
        let path = randomSlash(start)
        paths.append(path)

        currentIndex += 1 // Increment index for next position
    }

    // Function to draw random slashes (like 10PRINT)
    func randomSlash(_ start: CGPoint) -> Path {
        var path = Path()
        let end = Bool.random() ?
            CGPoint(x: start.x + gridSize, y: start.y + gridSize) :
            CGPoint(x: start.x, y: start.y + gridSize)
        
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
