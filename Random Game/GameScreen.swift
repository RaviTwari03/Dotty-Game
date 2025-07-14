//
//  Untitled.swift
//  Random Game
//
//  Created by Ravi Tiwari on 14/07/25.
//

import SwiftUI

struct GameScreen: View {
    @Binding var path: [String]
    @State private var showHint = false
    @StateObject private var puzzleManager = PuzzleManager()
    @State private var undoTrigger = false
    @State private var clearTrigger = false
    @State private var timerValue: Int = 0
    @State private var timerActive: Bool = false
    @State private var score: Int = 0
    @State private var timer: Timer? = nil
    @State private var showLevelCompletePopup = false
    
    // Timer logic
    func startTimer() {
        timer?.invalidate()
        timerValue = 0
        timerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timerActive {
                timerValue += 1
            }
        }
    }
    func resetTimerAndScore() {
        timer?.invalidate()
        timerValue = 0
        score = 0
        timerActive = true
    }
    func timeString(from seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    var body: some View {
        ZStack {
            // Start timer when view appears or puzzle changes
            Color.clear
                .onAppear(perform: startTimer)
                .onChange(of: puzzleManager.currentLevelIndex) { _ in
                    resetTimerAndScore()
                    startTimer()
                }
        
            LinearGradient(gradient: Gradient(colors: [Color(red:0.7, green:0.9, blue:1), Color(red:0.9, green:0.95, blue:1)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                // Top Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        Button("Home") {
                    path = []
                }
                        .buttonStyle(ModernButtonStyle(color: .blue, icon: "house"))
                        Button("Undo") { undoTrigger.toggle() }
                            .buttonStyle(ModernButtonStyle(color: .pink, icon: "arrow.uturn.left"))
                        Button("Clear") {
                            clearTrigger.toggle()
                            score = 0
                        }
                        .buttonStyle(ModernButtonStyle(color: .red, icon: "trash"))
                        Button("Hint") {
                            showHint = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { showHint = false }
                        }
                        .buttonStyle(ModernButtonStyle(color: .green, icon: "lightbulb"))
                        Button("Next") { puzzleManager.nextLevel() }
                            .buttonStyle(ModernButtonStyle(color: .purple, icon: "arrow.right"))

                    }
                    .padding(.horizontal)
                    .padding(.top, 18)
                }
                // Puzzle Canvas
                Spacer(minLength: 0)
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.5))
                        .shadow(color: .blue.opacity(0.08), radius: 18, x: 0, y: 8)
                    PuzzleCanvasView(
                        level: puzzleManager.currentLevel,
                        undoTrigger: $undoTrigger,
                        clearTrigger: $clearTrigger,
                        showHint: showHint,
                        onCorrectConnection: {
                            score += 1
                        },
                        onPuzzleComplete: {
                            timerActive = false
                            showLevelCompletePopup = true
                        }
                    )
                    .id(puzzleManager.currentLevelIndex) // Reset drawn lines on level change
                    .padding(8)
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                            removal: .move(edge: .leading).combined(with: .opacity)))
                    .animation(.easeInOut(duration: 0.45), value: puzzleManager.currentLevelIndex)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: 500, minHeight: 380, maxHeight: 420)
                Spacer(minLength: 0)
                // Timer & Score
                HStack {
                    Label {
                        Text("Level: \(puzzleManager.currentLevelIndex + 1)").font(.title3.bold())
                    } icon: {
                        Image(systemName: "number.square").foregroundColor(.blue)
                    }
                    Spacer()
                    Label {
                        Text("Score: \(score)").font(.title3.bold())
                    } icon: {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial, in: Capsule())
                .shadow(radius: 7, y: 2)
                .padding(.bottom, 22)
            }
            // Level Complete Popup
            if showLevelCompletePopup {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                VStack(spacing: 18) {
                    Text("🎉 Level Complete! 🎉")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .shadow(radius: 8)
                    Text("Great job! Ready for the next challenge?")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            showLevelCompletePopup = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                            puzzleManager.nextLevel()
                        }
                    }) {
                        Text("Next Level")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 36)
                            .padding(.vertical, 12)
                            .background(Color.purple)
                            .clipShape(Capsule())
                            .shadow(radius: 6)
                    }
                }
                .padding(36)
                .background(Color.purple.opacity(0.92))
                .cornerRadius(32)
                .shadow(radius: 22)
                .frame(maxWidth: 340)
                .transition(.scale.combined(with: .opacity))
                .zIndex(100)
            }
            // Animated confetti/emoji popup would go here
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameScreen(path: .constant([]))
        }
    }
}
