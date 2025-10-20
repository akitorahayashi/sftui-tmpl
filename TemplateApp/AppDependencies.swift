import Foundation

/// DI container that manages all app dependencies
struct AppDependencies {
    let countLogic: CountLogicProtocol

    /// Generate dependencies for production environment
    static func live() -> AppDependencies {
        AppDependencies(countLogic: LiveCountLogic())
    }
}

#if DEBUG
    extension AppDependencies {
        /// Generate mock dependencies for testing or previews
        static func mock(countLogic: CountLogicProtocol = MockCountLogic()) -> AppDependencies {
            AppDependencies(countLogic: countLogic)
        }

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
                return self.countToReturn
            }
        }
    }
#endif
