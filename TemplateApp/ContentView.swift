import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel

    // Accept AppDependencies in initializer
    init(dependencies: AppDependencies) {
        _viewModel = StateObject(
            wrappedValue: ContentViewModel(logic: dependencies.countLogic)
        )
    }

    var body: some View {
        VStack {
            if self.viewModel.isLoading {
                ProgressView()
            } else {
                Text("Count: \(self.viewModel.count)")
                    .font(.largeTitle)
            }
        }
        .task {
            await self.viewModel.onAppear()
        }
    }
}

#if DEBUG
    #Preview {
        // Always use mock dependencies in previews
        ContentView(dependencies: .mock())
    }
#endif
