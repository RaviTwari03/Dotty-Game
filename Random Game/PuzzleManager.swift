import SwiftUI

struct PuzzleLevel {
    let topDots: [Dot]
    let bottomDots: [Dot]
    let correctPairs: [(Int, Int)]
}

class PuzzleManager: ObservableObject {
    @Published var levels: [PuzzleLevel] = [
        PuzzleLevel(
            topDots: [
                Dot(color: .red, position: CGPoint(x: 0.1, y: 0)),
                Dot(color: .blue, position: CGPoint(x: 0.4, y: 0)),
                Dot(color: .green, position: CGPoint(x: 0.7, y: 0)),
                Dot(color: .yellow, position: CGPoint(x: 0.9, y: 0)),
            ],
            bottomDots: [
                Dot(color: .red, position: CGPoint(x: 0.1, y: 1)),
                Dot(color: .blue, position: CGPoint(x: 0.4, y: 1)),
                Dot(color: .green, position: CGPoint(x: 0.7, y: 1)),
                Dot(color: .yellow, position: CGPoint(x: 0.9, y: 1)),
            ],
            correctPairs: [(0,0),(1,1),(2,2),(3,3)]
        ),
        PuzzleLevel(
            topDots: [
                Dot(color: .red, position: CGPoint(x: 0.2, y: 0)),
                Dot(color: .blue, position: CGPoint(x: 0.5, y: 0)),
                Dot(color: .green, position: CGPoint(x: 0.8, y: 0)),
            ],
            bottomDots: [
                Dot(color: .green, position: CGPoint(x: 0.2, y: 1)),
                Dot(color: .red, position: CGPoint(x: 0.5, y: 1)),
                Dot(color: .blue, position: CGPoint(x: 0.8, y: 1)),
            ],
            correctPairs: [(0,1),(1,2),(2,0)]
        ),
        // Add more levels here
        PuzzleManager.randomLevel(dotCount: 4),
        PuzzleManager.randomLevel(dotCount: 5),
        PuzzleManager.randomLevel(dotCount: 6)
    ]
    @Published var currentLevelIndex: Int = 0
    var currentLevel: PuzzleLevel { levels[currentLevelIndex] }
    
    func nextLevel() {
        if currentLevelIndex + 1 < levels.count {
            currentLevelIndex += 1
        }
    }
    func reset() {
        currentLevelIndex = 0
    }
    // Helper to create a random level
    static func randomLevel(dotCount: Int, tricky: Bool = true) -> PuzzleLevel {
        // Choose colors
        let baseColors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .mint]
        let colors = Array(baseColors.shuffled().prefix(dotCount))
        // Generate random x positions, spaced out and not too close
        func spacedRandomXs(n: Int, minSpacing: CGFloat = 0.18) -> [CGFloat] {
            var xs: [CGFloat] = []
            let tries = 200
            let min = 0.08, max = 0.92
            outer: for _ in 0..<tries {
                xs = []
                for _ in 0..<n {
                    var candidate: CGFloat = 0
                    var attempts = 0
                    repeat {
                        candidate = CGFloat.random(in: min...max)
                        attempts += 1
                    } while xs.contains(where: { abs($0 - candidate) < minSpacing }) && attempts < 30
                    if attempts >= 30 { continue outer }
                    xs.append(candidate)
                }
                xs.sort()
                if (1..<xs.count).allSatisfy({ abs(xs[$0] - xs[$0-1]) >= minSpacing }) {
                    break
                }
            }
            // fallback to evenly spaced if failed
            if xs.isEmpty {
                xs = (1...n).map { CGFloat($0) / CGFloat(n+1) }
            }
            return xs
        }
        var topXs = spacedRandomXs(n: dotCount)
        var botXs = spacedRandomXs(n: dotCount)
        if topXs.count != dotCount {
            topXs = (1...dotCount).map { CGFloat($0) / CGFloat(dotCount+1) }
        }
        if botXs.count != dotCount {
            botXs = (1...dotCount).map { CGFloat($0) / CGFloat(dotCount+1) }
        }
        let topDots = (0..<dotCount).map { i in Dot(color: colors[i], position: CGPoint(x: topXs[i], y: 0)) }
        var bottomColors = colors
        if tricky {
            repeat {
                bottomColors.shuffle()
            } while bottomColors == colors && dotCount > 2 // ensure not same as top
        }
        let bottomDots = (0..<dotCount).map { i in Dot(color: bottomColors[i], position: CGPoint(x: botXs[i], y: 1)) }
        // Pair by color (each top dot to the bottom dot of the same color)
        var correctPairs: [(Int, Int)] = []
        for (i, topDot) in topDots.enumerated() {
            if let j = bottomDots.firstIndex(where: { $0.color == topDot.color }) {
                correctPairs.append((i, j))
            }
        }
        return PuzzleLevel(topDots: topDots, bottomDots: bottomDots, correctPairs: correctPairs)
    }
}

