import SwiftUI

struct RiverProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Однотонный зеленый фон
                Color.green
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Название игры
                    Text("River City")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
                    
                    // Прогресс-бар
                    SimpleProgressBar(progress: progress)
                        .frame(height: 18)
                        .padding(.horizontal, 40)
                    
                    // Текст загрузки
                    Text("Loading... \(Int(progress * 100))%")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                    
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

private struct SimpleProgressBar: View {
    let progress: Double

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.white.opacity(0.2))
                .frame(height: 18)
            Capsule()
                .fill(Color.white)
                .frame(width: CGFloat(progress) * 260, height: 18)
                .shadow(color: .white.opacity(0.5), radius: 6)
        }
        .animation(.easeInOut(duration: 0.7), value: progress)
    }
}

#Preview {
    RiverProgressBar(progress: 0.75)
}
