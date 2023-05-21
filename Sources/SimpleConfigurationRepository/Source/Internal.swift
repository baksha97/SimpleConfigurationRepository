import Foundation

extension SimpleConfigurationRepository.Settings {
  func build() -> any ConfigurationRepository<M> {
    ConfigurationRepositoryImpl(
      fallback: fallback,
      local: build(),
      remote: build()
    )
  }
  
  private func build() -> any LocalDataSource<M> {
    switch mode {
    case .fileManager:
      return FileDataSource()
    case .userDefaults(let userDefaults):
      return DefaultsDataSource(storage: userDefaults)
    }
  }
  
  private func build() -> any RemoteDatasource<M> {
    WebDataSource(url: location)
  }
}

protocol LocalDataSource<Configuration> where Configuration: ConfigurationModel {
  associatedtype Configuration
  var cache: Configuration { get throws }
  func persist(_ config: Configuration) throws
}

protocol RemoteDatasource<Configuration> where Configuration: ConfigurationModel {
  associatedtype Configuration
  var url: URL { get }
  func fetch() async throws -> Configuration
}

extension ConfigurationModel {
  static var exactModelIdentifier: String {
    "\(identifier)_\(version)"
  }
}
