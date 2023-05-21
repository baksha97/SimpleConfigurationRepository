import Foundation

extension ConfigurationModel {
  static var exactModelIdentifier: String {
    "\(identifier)_\(version)"
  }
}

protocol ConfigurationLocalDataSource<Configuration> where Configuration: ConfigurationModel {
  associatedtype Configuration
  func fetch() throws -> Configuration
  func persist(_ config: Configuration) throws
}

protocol ConfigurationRemoteDatasource<Configuration> where Configuration: ConfigurationModel {
  associatedtype Configuration
  var url: URL { get }
  func fetch() async throws -> Configuration
}

extension Settings {
  func build() -> any ConfigurationRepository<M> {
    ConfigurationRepositoryImpl(
      fallback: fallback,
      local: resolve(local: local),
      remote: RemoteConfigFetcher(url: remote)
    )
  }
  
  private func resolve<M: ConfigurationModel>(local: LocalDataSourceType) -> any ConfigurationLocalDataSource<M> {
    switch local {
    case .filestorage:
        return FileConfigCacheable<M>()
    case .userDefaults(let userDefaults):
      return UserDefaultsConfigCacheable<M>(storage: userDefaults)
    }
  }
}
