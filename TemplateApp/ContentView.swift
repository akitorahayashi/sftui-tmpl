import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel

    init(viewModel: ContentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Text("Count: \(viewModel.count)")
                    .font(.largeTitle)
            }
        }
        .task {
            await viewModel.onAppear()
        }
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel(logic: LiveCountLogic()))
}
