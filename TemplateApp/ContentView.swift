import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel

    init(viewModel: ContentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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

#Preview {
    ContentView(viewModel: ContentViewModel(logic: LiveCountLogic()))
}
