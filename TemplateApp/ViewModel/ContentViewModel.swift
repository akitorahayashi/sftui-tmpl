import Combine
import Foundation

@MainActor
final class ContentViewModel: ObservableObject {
    @Published private(set) var count: Int = 0
    @Published private(set) var isLoading = false

    private let logic: CountLogicProtocol

    init(logic: CountLogicProtocol) {
        self.logic = logic
    }

    func onAppear() async {
        self.isLoading = true
        defer { isLoading = false }
        do {
            self.count = try await self.logic.fetchCurrentCount()
        } catch {
            print("Failed to fetch count: \(error)")
        }
    }
}
