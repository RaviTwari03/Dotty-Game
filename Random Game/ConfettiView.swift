import SwiftUI

struct ConfettiView: View {
    @Binding var show: Bool
    var body: some View {
        ZStack {
            if show {
                ForEach(0..<25) { i in
                    ConfettiParticle()
                        .opacity(show ? 1 : 0)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.easeOut(duration: 1.2).delay(Double(i) * 0.03), value: show)
                }
                Text("🎉")
                    .font(.system(size: 80))
                    .shadow(color: .yellow.opacity(0.6), radius: 18)
                    .scaleEffect(show ? 1.2 : 0.5)
                    .opacity(show ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.4), value: show)
            }
        }
        .allowsHitTesting(false)
    }
}

struct ConfettiParticle: View {
    @State private var pos: CGSize = .zero
    @State private var angle: Double = 0
    let color: Color = [Color.red, .yellow, .blue, .green, .purple, .orange].randomElement()!
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 16, height: 16)
            .offset(pos)
            .rotationEffect(.degrees(angle))
            .onAppear {
                withAnimation(.easeOut(duration: 1.2)) {
                    pos = CGSize(width: Double.random(in: -120...120), height: Double.random(in: 80...240))
                    angle = Double.random(in: 0...360)
                }
            }
    }
}

struct ConfettiView_Previews: PreviewProvider {
    static var previews: some View {
        ConfettiView(show: .constant(true))
            .background(Color.blue.opacity(0.2))
    }
}
