import XCTest
@testable import TemplateApp

@MainActor
final class FeatureTests: XCTestCase {
    func test_onAppear_countIsUpdated() async {
        let mockLogic = MockCountLogic()
        mockLogic.countToReturn = 42
        let viewModel = ContentViewModel(logic: mockLogic)

        await viewModel.onAppear()

        XCTAssertEqual(viewModel.count, 42, "Count should be updated correctly")
        XCTAssertFalse(viewModel.isLoading, "Loading should be finished")
    }
}
