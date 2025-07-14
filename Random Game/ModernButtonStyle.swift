import SwiftUI

struct ModernButtonStyle: ButtonStyle {
    var color: Color
    var icon: String? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.headline)
            }
            configuration.label
                .font(.headline)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(color)
                .shadow(color: color.opacity(0.25), radius: 7, x: 0, y: 3)
        )
        .foregroundColor(.white)
        .scaleEffect(configuration.isPressed ? 0.95 : 1.05)
        .opacity(configuration.isPressed ? 0.8 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
