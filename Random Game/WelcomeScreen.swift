//
//  WelcomeScreen.swift
//  Random Game
//
//  Created by Ravi Tiwari on 14/07/25.
//

import SwiftUI

struct WelcomeScreen: View {
    var onExplore: () -> Void = {}
    var onStartGame: () -> Void = {}
    var body: some View {
        VStack {
            HStack {
                Button("Settings") {}
                    .buttonStyle(.bordered)
                    .padding(.leading)
                Spacer()
                Button("Explore", action: onExplore)
                    .buttonStyle(.bordered)
                    .padding(.trailing)
            }
            .padding(.top)
            Spacer()
            Text("Welcome to Dotty Match Quest")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            Button("Start Game", action: onStartGame)
                .buttonStyle(.borderedProminent)
                .font(.title2)
                .padding(.bottom, 40)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WelcomeScreen()
        }
    }
}
