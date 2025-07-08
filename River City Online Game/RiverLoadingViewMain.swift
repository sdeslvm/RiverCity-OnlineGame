import SwiftUI

struct RiverScreen: View {
    @StateObject var viewModel: RiverViewModel

    init(viewModel: RiverViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            RiverWebStage(viewModel: viewModel)
                .opacity(viewModel.riverStatus == .completed ? 1 : 0)
            RiverOverlay(state: viewModel.riverStatus)
        }
    }
}

private struct RiverOverlay: View {
    let state: RiverState

    var body: some View {
        switch state {
        case .loading(let progress):
            RiverProgressBar(progress: progress)
        case .failed(let error):
            Text("Error: \(error.localizedDescription)").foregroundColor(.pink)
        case .offline:
            Text("Offline").foregroundColor(.gray)
        default:
            EmptyView()
        }
    }
}
