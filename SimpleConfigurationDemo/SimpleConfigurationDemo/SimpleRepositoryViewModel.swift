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
  var error: Error? = nil
}

@MainActor
class SimpleRepositoryViewModel: ObservableObject {
  @Published var state: ViewState = .init()
  private let repository: any ConfigurationRepository<SampleConfiguration>
  
  init() {
    repository = SimpleConfigurationRepository.build(
      settings: .init(
        fallback: .fallback,
        mode: .userDefaults(.standard),
        location: .bucket
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
