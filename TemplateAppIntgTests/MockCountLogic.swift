@testable import TemplateApp

final class MockCountLogic: CountLogicProtocol {
    var countToReturn: Int = 0

    func fetchCurrentCount() async -> Int {
        countToReturn
    }
}
