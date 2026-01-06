import Foundation

protocol CountLogicProtocol: Sendable {
  func fetchCurrentCount() async throws -> Int
}
