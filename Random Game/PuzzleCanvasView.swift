import SwiftUI

struct Dot: Identifiable, Equatable {
    let id = UUID()
    let color: Color
    let position: CGPoint // Relative (0...1)
}

struct DotPair {
    let topDot: Dot
    let bottomDot: Dot
}

struct DrawnLine: Identifiable, Equatable {
    let id = UUID()
    let from: Dot
    let to: Dot
    let isCorrect: Bool?
    static func == (lhs: DrawnLine, rhs: DrawnLine) -> Bool {
        lhs.id == rhs.id
    }
}

struct PuzzleCanvasView: View {
    let level: PuzzleLevel
    @Binding var undoTrigger: Bool
    @Binding var clearTrigger: Bool
    var showHint: Bool = false
    var onCorrectConnection: (() -> Void)? = nil
    var onPuzzleComplete: (() -> Void)? = nil
    
    @State private var drawnLines: [DrawnLine] = []
    @State private var tempLine: (from: Dot, to: CGPoint)? = nil
    @State private var showConfetti = false
    @State private var showClearAnimation = false
    @Namespace private var animation
    
    var allCorrect: Bool {
        drawnLines.count == level.correctPairs.count && drawnLines.allSatisfy { $0.isCorrect == true }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Clear animation overlay
                if showClearAnimation {
                    ConfettiView(show: $showClearAnimation)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(10)
                    Text("🧹✨")
                        .font(.system(size: 60))
                        .shadow(color: .yellow.opacity(0.7), radius: 12)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(11)
                }
                // Draw dashed border
                RoundedRectangle(cornerRadius: 24)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                    .foregroundColor(.gray.opacity(0.5))
                // Draw lines
                ForEach(drawnLines) { line in
                    Path { path in
                        let from = absPos(for: line.from, in: geo.size)
                        let to = absPos(for: line.to, in: geo.size)
                        path.move(to: from)
                        path.addLine(to: to)
                    }
                    .stroke(line.isCorrect == true ? Color.green : (line.isCorrect == false ? Color.red : Color.gray), style: StrokeStyle(lineWidth: 4, dash: [8]))
                    .animation(.easeInOut, value: drawnLines)
                }
                // Draw temp line
                if let temp = tempLine {
                    Path { path in
                        let from = absPos(for: temp.from, in: geo.size)
                        path.move(to: from)
                        path.addLine(to: temp.to)
                    }
                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 3, dash: [8]))
                }
                // Draw dots
                // Find a correct pair to hint
                var hintPair: (Int, Int)? {
                    if showHint {
                        for pair in level.correctPairs {
                            let alreadyDrawn = drawnLines.contains { $0.from == level.topDots[pair.0] && $0.to == level.bottomDots[pair.1] }
                            if !alreadyDrawn { return pair }
                        }
                    }
                    return nil
                }
                ForEach(0..<level.topDots.count, id: \.self) { idx in
                    let dot = level.topDots[idx]
                    Circle()
                        .fill(dot.color)
                        .frame(width: 48, height: 48)
                        .shadow(color: dot.color.opacity(0.35), radius: 10, x: 0, y: 4)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .shadow(color: dot.color.opacity(0.7), radius: 8)
                        )
                        .overlay(
                            // Hint highlight
                            Group {
                                if let hint = hintPair, hint.0 == idx {
                                    Circle()
                                        .stroke(Color.yellow,
                                                style: StrokeStyle(lineWidth: 7, dash: [6]))
                                        .shadow(color: .yellow, radius: 12)
                                        .opacity(0.85)
                                        .scaleEffect(1.18)
                                        .animation(.easeInOut.repeatForever(autoreverses: true), value: showHint)
                                }
                            }
                        )
                        .position(absPos(for: dot, in: geo.size))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    tempLine = (from: dot, to: value.location)
                                }
                                .onEnded { value in
                                    tempLine = nil
                                    // Check if drag ended near a bottom dot
                                    let end = value.location
                                    if let targetIdx = level.bottomDots.enumerated().min(by: { lhs, rhs in
                                        let d1 = distance(absPos(for: lhs.element, in: geo.size), end)
                                        let d2 = distance(absPos(for: rhs.element, in: geo.size), end)
                                        return d1 < d2
                                    })?.offset {
                                        let bottomDotPos = absPos(for: level.bottomDots[targetIdx], in: geo.size)
                                        if distance(bottomDotPos, end) < 36 {
                                            // Make connection
                                            // Prevent multiple lines from the same top dot
                                            if drawnLines.contains(where: { $0.from == level.topDots[idx] }) {
                                                return
                                            }
                                            // Only allow correctPairs as valid connections
                                            if let correctPair = level.correctPairs.first(where: { $0.0 == idx && $0.1 == targetIdx }) {
                                                let newLine = DrawnLine(from: level.topDots[idx], to: level.bottomDots[targetIdx], isCorrect: true)
                                                drawnLines.append(newLine)
                                                SoundManager.shared.play(.correct)
                                                onCorrectConnection?()
                                                if drawnLines.count == level.correctPairs.count && drawnLines.allSatisfy({ $0.isCorrect == true }) {
                                                    showConfetti = true
                                                    SoundManager.shared.play(.success)
                                                    onPuzzleComplete?()
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                        showConfetti = false
                                                    }
                                                }
                                            } else {
                                                // Not a valid connection
                                                let newLine = DrawnLine(from: level.topDots[idx], to: level.bottomDots[targetIdx], isCorrect: false)
                                                drawnLines.append(newLine)
                                                SoundManager.shared.play(.wrong)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                                    drawnLines.removeAll { $0.id == newLine.id }
                                                }
                                            }
                                        }
                                    }
                                }
                        )
                }
                ForEach(0..<level.bottomDots.count, id: \.self) { idx in
                    let dot = level.bottomDots[idx]
                    Circle()
                        .fill(dot.color)
                        .frame(width: 48, height: 48)
                        .shadow(color: dot.color.opacity(0.35), radius: 10, x: 0, y: 4)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .shadow(color: dot.color.opacity(0.7), radius: 8)
                        )
                        .overlay(
                            // Hint highlight
                            Group {
                                if let hint = hintPair, hint.1 == idx {
                                    Circle()
                                        .stroke(Color.yellow,
                                                style: StrokeStyle(lineWidth: 7, dash: [6]))
                                        .shadow(color: .yellow, radius: 12)
                                        .opacity(0.85)
                                        .scaleEffect(1.18)
                                        .animation(.easeInOut.repeatForever(autoreverses: true), value: showHint)
                                }
                            }
                        )
                        .position(absPos(for: dot, in: geo.size))
                }
            }
            .contentShape(Rectangle())
            handleTriggers()

        }
    }
    
    func absPos(for dot: Dot, in size: CGSize) -> CGPoint {
        CGPoint(x: dot.position.x * size.width, y: dot.position.y * size.height)
    }
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
    }
    // Undo/Clear logic using @State
    private func handleUndo() {
        if !drawnLines.isEmpty { drawnLines.removeLast() }
    }
    private func handleClear() {
        drawnLines.removeAll()
        // Show clear animation
        showClearAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showClearAnimation = false
        }
    }
    // React to triggers
    @ViewBuilder
    private func handleTriggers() -> some View {
        EmptyView()
            .onChange(of: undoTrigger) { _ in handleUndo() }
            .onChange(of: clearTrigger) { _ in handleClear() }
    }
    
    struct PuzzleCanvasView_Previews: PreviewProvider {
        @State static var dummyUndo = false
        @State static var dummyClear = false
        static var previews: some View {
            PuzzleCanvasView(
                level: PuzzleLevel(
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
                undoTrigger: $dummyUndo,
                clearTrigger: $dummyClear
            )
            .frame(height: 400)
        }
    }
}
