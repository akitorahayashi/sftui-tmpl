import Foundation

protocol CountLogicProtocol {
    func fetchCurrentCount() async -> Int
}

final class LiveCountLogic: CountLogicProtocol {
    func fetchCurrentCount() async -> Int {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return 100
    }
}
