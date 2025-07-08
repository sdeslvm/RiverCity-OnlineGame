import SwiftUI

struct RiverProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Фон трассы
//                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.6)]),
//                               startPoint: .top,
//                               endPoint: .bottom)
//                    .ignoresSafeArea()
                
                VStack(spacing: 50) {
                    Spacer()
                    
                    // Бегущие трассы
                    TrackLines(progress: progress)
                        .frame(height: 100)
                    
                    // Прогресс-текст
                    Text("Race loading: \(Int(progress * 100))%")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 4, x: 2, y: 2)
                    
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                Image(.background)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.5)
                    .frame(width: geo.size.width, height: geo.size.height)
            )
        }
    }
}

private struct TrackLines: View {
    let progress: Double
    @State private var animate = false

    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<4) { track in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 12)
                    
                    Capsule()
                        .fill(Color.yellow)
                        .frame(width: animate ? CGFloat(progress) * 300 : 0, height: 12)
                        .shadow(color: .yellow, radius: 8)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false), value: animate)
                }
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    RiverProgressBar(progress: 0.75)
}
