import AVFoundation
import SwiftUI

class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    enum SoundType: String {
        case correct = "ding"
        case wrong = "buzz"
        case success = "cheer"
    }

    func play(_ type: SoundType) {
        guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "wav") else {
            print("[SoundManager] Missing sound file: \(type.rawValue).wav")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Failed to play sound: \(error)")
        }
    }
}
