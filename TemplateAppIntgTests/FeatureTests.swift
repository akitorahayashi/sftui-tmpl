@testable import TemplateApp
import XCTest

@MainActor
final class FeatureTests: XCTestCase {
    func test_onAppear_countIsUpdated() async {
        // 1. Prepare mock logic for testing
        let mockLogic = MockCountLogic()
        mockLogic.countToReturn = 42

        // 2. Generate DI container with mock logic
        let dependencies = AppDependencies.mock(mockCountLogic: mockLogic)

        // 3. Generate ViewModel from DI container
        let viewModel = ContentViewModel(logic: dependencies.countLogic)

        // 4. Execute test
        await viewModel.onAppear()

        // 5. Verify results
        XCTAssertEqual(viewModel.count, 42, "Count should be updated correctly")
        XCTAssertFalse(viewModel.isLoading, "Loading should be finished")
    }
}
