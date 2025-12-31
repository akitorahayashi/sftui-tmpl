import Foundation

final class LiveCountLogic: CountLogicProtocol {
    func fetchCurrentCount() async throws -> Int {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return 100
    }
}
