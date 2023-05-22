import SwiftUI
import SimpleConfigurationRepository


struct MySimpleConfig: SimpleConfigurationRepository.Model {
  var id: Int { version }
  let version: Int
  let value: String
  static var modelIdentifier: String = "MySimpleConfig"
  static var modelVersion: Int = 1
}

struct SimpleRepositoryView: View {
  @StateObject
  var viewModel = SimpleRepostioryViewModel()
  
  var body: some View {
    VStack {
      result
      Divider()
      actions
    }.onAppear(perform: viewModel.fetch)
  }
  
  @ViewBuilder
  var result: some View {
    if let configurationResult = viewModel.state.result {
      Text(String(describing: configurationResult))
    }
  }
  
  var actions: some View {
    Button("Perform Update") {
      viewModel.update()
    }
  }
}

@MainActor
class SimpleRepostioryViewModel: ObservableObject {
  private let bucket: URL =
    .init(
      string: "https://raw.githubusercontent.com/baksha97/SimpleConfigurationRepository/main/config.json"
    )!
  
  private let fallback: MySimpleConfig =
    .init(
      version: 1,
      value: "Fallback"
    )
  
  @Published var state: State = .init()
  
  private let repository: any ConfigurationRepository<MySimpleConfig>
  init() {
    repository = SimpleConfigurationRepository.build(
      settings: .init(
        fallback: fallback,
        mode: .fileManager,
        location: bucket
      )
    )
  }
  
  func fetch() {
    state.result = repository.current
  }
  
  func update() {
    Task {
      do {
        state.result = try await repository.update()
      } catch {
        state.error = error
      }
    }
  }
  
  struct State {
    var result: SimpleConfigurationRepository.Result<MySimpleConfig>? = nil
    var error: Error? = nil
  }
  
}

struct SimpleRepositoryView_Previews: PreviewProvider {
  static var previews: some View {
    SimpleRepositoryView()
  }
}
