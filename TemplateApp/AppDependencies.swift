import Foundation

/// DI container that manages all app dependencies
struct AppDependencies {
    let countLogic: CountLogicProtocol

    /// Generate dependencies for production environment
    static func live() -> AppDependencies {
        return AppDependencies(countLogic: LiveCountLogic())
    }

    /// Generate mock dependencies for testing or previews
    static func mock(mockCountLogic: CountLogicProtocol? = nil) -> AppDependencies {
        // Use default mock implementation if not specified in arguments
        let logic = mockCountLogic ?? MockCountLogic()
        return AppDependencies(countLogic: logic)
    }
}

#if DEBUG
// Move or define mock classes within the DI container file
// so that test targets can access `MockCountLogic`.
final class MockCountLogic: CountLogicProtocol {
    var countToReturn: Int = 0
    var errorToThrow: Error?

    func fetchCurrentCount() async throws -> Int {
        if let error = errorToThrow {
            throw error
        }
        // Return the value set in tests
        return countToReturn
    }
}
#endif
