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
        isLoading = true
        count = await logic.fetchCurrentCount()
        isLoading = false
    }
}
