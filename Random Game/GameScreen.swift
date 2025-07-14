//
//  Untitled.swift
//  Random Game
//
//  Created by Ravi Tiwari on 14/07/25.
//

import SwiftUI

struct GameScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            // Top Buttons
            HStack {
                Button("Home") {}
                    .buttonStyle(.bordered)
                Button("Hint") {}
                    .buttonStyle(.bordered)
                Button("Next") {}
                    .buttonStyle(.bordered)
                Button("Share") {}
                    .buttonStyle(.bordered)
                Button("Rate") {}
                    .buttonStyle(.bordered)
            }
            .padding(.top)
            // Puzzle Canvas Placeholder
            Spacer()
            RoundedRectangle(cornerRadius: 24)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                .foregroundColor(.gray.opacity(0.5))
                .frame(height: 350)
                .overlay(
                    Text("Puzzle Canvas")
                        .foregroundColor(.gray)
                )
                .padding()
            Spacer()
            // Timer & Score
            HStack {
                Label("00:00", systemImage: "timer")
                    .font(.title2)
                Spacer()
                Label("Score: 0", systemImage: "star.fill")
                    .font(.title2)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameScreen()
        }
    }
}
