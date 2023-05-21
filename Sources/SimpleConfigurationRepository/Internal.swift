import Foundation

extension SimpleConfigurationRepository.Settings {
  func build() -> any ConfigurationRepository<M> {
    ConfigurationRepositoryImpl(
      fallback: fallback,
      local: resolve(local: local),
      remote: WebDataSource(url: remote)
    )
  }
  
  private func resolve<M: ConfigurationModel>(local: Storage) -> any LocalDataSource<M> {
    switch local {
    case .filestorage:
        return FileDataSource<M>()
    case .userDefaults(let userDefaults):
      return DefaultsDataSource<M>(storage: userDefaults)
    }
  }
}

protocol LocalDataSource<Configuration> where Configuration: ConfigurationModel {
  associatedtype Configuration
  func fetch() throws -> Configuration
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
