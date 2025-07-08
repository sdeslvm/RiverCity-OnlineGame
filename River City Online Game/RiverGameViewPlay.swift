import Foundation
import SwiftUI

final class RiverColor: UIColor {
    convenience init(rgb: String) {
        let clean = rgb.trimmingCharacters(in: .alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&value)
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

func launchRiver() -> some View {
    let viewModel = RiverViewModel(url: URL(string: "https://rivecitonline.run/game")!)
    return RiverScreen(viewModel: viewModel)
        .background(Color(RiverColor(rgb: "#000000")))
}

struct RiverEntry: View {
    var body: some View {
        launchRiver()
    }
}

#Preview {
    RiverEntry()
}
