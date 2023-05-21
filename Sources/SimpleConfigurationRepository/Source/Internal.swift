import Foundation

extension SimpleConfigurationRepository.Settings {
  /// Builds and returns a configuration repository based on the current settings.
  /// - Returns: An instance of `ConfigurationRepository` that corresponds to the settings.
  internal func build() -> any ConfigurationRepository<M> {
    ConfigurationRepositoryImpl(
      fallback: fallback,
      local: build(),
      remote: build()
    )
  }
  
  /// Builds and returns a local data source based on the current mode.
  /// - Returns: An instance of `LocalDataSource` corresponding to the mode.
  private func build() -> any LocalDataSource<M> {
    switch mode {
    case .fileManager:
      return FileDataSource()
    case .userDefaults(let userDefaults):
      return DefaultsDataSource(storage: userDefaults)
    }
  }
  
  /// Builds and returns a remote data source using the specified URL location.
  /// - Returns: An instance of `RemoteDatasource` with the provided URL.
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
  /// Returns a string representing the exact model identifier.
  ///
  /// The exact model identifier is constructed by appending the identifier and version of the configuration model.
  ///
  /// - Returns: A string in the format "identifier_version".
  static var exactModelIdentifier: String {
    "\(modelIdentifier)_\(modelVersion)"
  }
}
