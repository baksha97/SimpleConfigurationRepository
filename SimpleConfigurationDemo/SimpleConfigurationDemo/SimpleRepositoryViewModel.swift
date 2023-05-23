import Foundation
import Combine
import SimpleConfigurationRepository

struct SampleConfiguration: SimpleConfigurationRepository.Model {
  var id: Int { version }
  let version: Int
  let value: String
  static var modelIdentifier: String = "MySimpleConfig"
  static var modelVersion: Int = 1
}

struct ViewState {
  var result: SimpleConfigurationRepository.Result<SampleConfiguration>? = nil
  var updateError: Error? = nil
  
  var hasResultAndError: Bool {
    result != nil && updateError != nil
  }
}

@MainActor
class SimpleRepositoryViewModel: ObservableObject {
  @Published var state: ViewState = .init()
  private let repository: any ConfigurationRepository<SampleConfiguration>
  
  init(mode: SimpleConfigurationRepository.LocalStorage) {
    self.repository = SimpleConfigurationRepository.build(
      settings: .init(
        fallback: .fallback,
        local: mode,
        remote: .session(.shared, location: .bucket)
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
        state.updateError = error
      }
    }
  }
}

fileprivate extension URL {
  static let bucket: URL =
    .init(
      string: "https://raw.githubusercontent.com/baksha97/SimpleConfigurationRepository/main/config.json"
    )!
}

fileprivate extension SampleConfiguration {
  static let fallback: SampleConfiguration =
    .init(
      version: 1,
      value: "Fallback"
    )
}
