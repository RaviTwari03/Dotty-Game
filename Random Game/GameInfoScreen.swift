//
//  GameInfoScreen.swift
//  Random Game
//
//  Created by Ravi Tiwari on 14/07/25.
//

import SwiftUI

struct GameInfoScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Back") {}
                    .buttonStyle(.bordered)
                Spacer()
                Button("Skip") {}
                    .buttonStyle(.bordered)
                Button("Share") {}
                    .buttonStyle(.bordered)
                Button("Rate") {}
                    .buttonStyle(.bordered)
            }
            .padding()
            Text("How to Play")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
            ScrollView {
                Text("Follow the dashed lines to connect the top colored dots to their matching bottom dots! Tap a top dot, then a bottom dot to draw a line. Get all matches correct to win! Use hints if you get stuck. Have fun!")
                    .font(.body)
                    .padding()
            }
            Spacer()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct GameInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameInfoScreen()
        }
    }
}
