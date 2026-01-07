@testable import TemplateApp
import XCTest

@MainActor
final class FeatureTests: XCTestCase {
  func test_onAppear_countIsUpdated() async {
    // Arrange
    let mockLogic = AppDependencies.MockCountLogic()
    mockLogic.countToReturn = 42
    let viewModel = ContentViewModel(logic: mockLogic)

    // Act
    await viewModel.onAppear()

    // Assert
    XCTAssertEqual(viewModel.count, 42, "Count should be updated correctly")
    XCTAssertFalse(viewModel.isLoading, "Loading should be finished")
  }
}
