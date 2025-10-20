@testable import TemplateApp

final class MockCountLogic: CountLogicProtocol {
    var countToReturn: Int = 0
    var errorToThrow: Error?

    func fetchCurrentCount() async throws -> Int {
        if let error = errorToThrow {
            throw error
        }
        return self.countToReturn
    }
}
