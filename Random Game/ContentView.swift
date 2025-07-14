//
//  ContentView.swift
//  Random Game
//
//  Created by Ravi Tiwari on 14/07/25.
//

import SwiftUI

struct ContentView: View {
    @State private var path: [String] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            WelcomeScreen(
                onExplore: { path.append("GameInfo") },
                onStartGame: { path.append("Game") }
            )
            .navigationDestination(for: String.self) { screen in
                switch screen {
                case "GameInfo":
                    GameInfoScreen()
                case "Game":
                    GameScreen(path: $path)
                default:
                    WelcomeScreen(
                        onExplore: { path.append("GameInfo") },
                        onStartGame: { path.append("Game") }
                    )
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
