import Foundation

protocol CountLogicProtocol {
    func fetchCurrentCount() async throws -> Int
}
