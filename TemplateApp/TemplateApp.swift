import SwiftUI

@main
struct TemplateApp: App {
  private let dependencies: AppDependencies

  init() {
    // Generate production dependencies at app launch
    self.dependencies = .live()
  }

  var body: some Scene {
    WindowGroup {
      // Inject generated dependencies into the view
      ContentView(dependencies: self.dependencies)
    }
  }
}
