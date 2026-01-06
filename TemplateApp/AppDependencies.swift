import Foundation

/// DI container that manages all app dependencies
struct AppDependencies: Sendable {
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
    @MainActor
    final class MockCountLogic: CountLogicProtocol {
      var countToReturn: Int = 0
      var errorToThrow: Error?

      nonisolated func fetchCurrentCount() async throws -> Int {
        let error = await self.errorToThrow
        if let error {
          throw error
        }
        // Return the value set in tests
        return await self.countToReturn
      }
    }
  }
#endif
