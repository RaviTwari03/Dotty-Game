# Dotty Match Quest

A fun, kid-friendly dot-connecting puzzle game built with SwiftUI for iOS and macOS.

## Features
- Drag to connect colored dots from top to bottom
- Only correct color pairs are accepted; incorrect connections show feedback
- Multiple puzzle levels with random and tricky dot arrangements
- Hint system to highlight a correct pair
- Undo and clear functionality
- Home button to return to the main menu
- Score tracking per level
- Colorful UI, smooth animations, and confetti/emoji celebration on success
- Designed for children: large touch targets, visual feedback, and no ads

## Screenshots
*(Add your screenshots here)*

## Getting Started

1. **Clone the repo:**
   ```sh
   git clone https://github.com/RaviTwari03/Dott-Matching-Game.git
   ```
2. **Open in Xcode:**
   Open the `.xcodeproj` or `.xcworkspace` file in Xcode.
3. **Build & Run:**
   Select a simulator or your device and click Run.

## Project Structure
- `ContentView.swift`: App entry and navigation
- `WelcomeScreen.swift`: Main menu
- `GameScreen.swift`: Main game interface
- `PuzzleManager.swift`: Level logic and random level generator
- `PuzzleCanvasView.swift`: Core puzzle logic and rendering
- `ModernButtonStyle.swift`: Custom button style
- `SoundManager.swift`: Plays feedback sounds
- `ConfettiView.swift`: Celebration animations
- `Assets.xcassets`: Sounds and images

## How to Play
- Connect each top dot to the matching colored bottom dot by dragging
- Use Undo or Clear to fix mistakes
- Use Hint if you get stuck
- Complete all pairs to finish the level!

## Credits
- Developed by Ravi Tiwari
- Sound effects and emojis from open/free resources

## License
MIT
