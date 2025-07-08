import Foundation

/// Состояние загрузки реки
enum RiverState: Equatable {
    case idle
    case loading(Double)
    case completed
    case failed(Error)
    case offline

    static func == (lhs: RiverState, rhs: RiverState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.completed, .completed), (.offline, .offline):
            return true
        case (.loading(let l), .loading(let r)):
            return l == r
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}

