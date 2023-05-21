import Foundation

public protocol ConfigurationModel: Codable & Identifiable & Equatable {
  /// Represents the version of the content within the model.
  var version: Int { get }
  
  /// Represents the identifier for the model class itself.
  static var identifier: String { get }
  
  /// Represents the version for the model contract itself.
  /// If you do not update this, we cannot identify the difference between failing to decode due to model changes versus corrupted data.
  static var version: Int { get }
}

enum ConfigurationDataSourceError: Error {
  case missingDocumentsDirectory
  case emptyCatch(underlying: Error?)
}

public enum ConfigurationResult<Configuration: ConfigurationModel> {
  case local(Configuration)
  case remote(Configuration, silentPersistenceFailure: Error?)
  case fallback(Configuration, cause: Error)
}

public protocol ConfigurationRepository<Configuration> where Configuration: ConfigurationModel {
  associatedtype Configuration//: ConfigurationModel
  
  var fallback: Configuration { get }
  var current: ConfigurationResult<Configuration> { get }
  
  func update() async throws -> ConfigurationResult<Configuration>
}

struct Settings {
  let fallback: ConfigurationModel
  let local: LocalDataSourceType
  let remote: URL
  
  enum LocalDataSourceType {
    case filestorage
    case userDefaults(UserDefaults)
  }
}

struct Config: ConfigurationModel {
  var version: Int = 1
  
  static var identifier: String = "ID"
  
  static var version: Int = 1
  var id: String { "Config" }
}

//internal struct Builder<
//  Model: ConfigurationModel
//> {
//
//  func build() -> some ConfigurationRepository<Model> {
//    ConfigurationRepositoryImpl(fallback: fallback,
//                                local: UserDefaultsConfigCacheable<Model>(storage: .standard),
//                                remote: RemoteConfigFetcher<Model>(url: remoteLocation))
//  }
//}

enum SimpleConfigurationRepository {
  func build<M>(
    settings: Settings
  ) -> some ConfigurationRepository<M> {
//    func resolveLocal()
    ConfigurationRepositoryImpl(
      fallback: settings.fallback,
      local: settings.local,
      remote: settings.remote
    )
  }
}

//internal struct ConfigurationRepositoryBuilder<
//  Model: ConfigurationModel,
//  RemoteDataSource: ConfigurationRemoteDatasource,
//  LocalDataSource: ConfigurationLocalDataSource,
//  LocalFileStorage: FileConfigCacheable<Model>,
//  LocalUserDefaultsStorage: UserDefaultsConfigCacheable<Model>,
//  Repository: ConfigurationRepository
//> where RemoteDataSource.Configuration == Model, LocalDataSource.Configuration == Model, Repository.Configuration == Model, LocalFileStorage == LocalDataSource {
//  private var fallback: Model?
//  private var localDataSource: LocalDataSource?
//  private var remoteDataSource: RemoteDataSource?
//
//  public func withFileStorage() -> Self {
//    var builder = self
//    let x: LocalFileStorage = FileConfigCacheable()
//    builder.localDataSource = x
//    return builder
//  }
//
//  public init() {}
//
//  public func withFallback(_ fallback: Model) -> Self {
//    var builder = self
//    builder.fallback = fallback
//    return builder
//  }
//
//  public func withLocalDataSource(_ localDataSource: LocalDataSource) -> Self {
//    var builder = self
//    builder.localDataSource = localDataSource
//    return builder
//  }
//
//
//
//
//  public func withRemoteDataSource(_ remoteDataSource: RemoteDataSource) -> Self {
//    var builder = self
//    builder.remoteDataSource = remoteDataSource
//    return builder
//  }
//
//  public func build() -> ConfigurationRepositoryImpl<Model, RemoteDataSource, LocalDataSource>? {
//    guard let fallback = fallback,
//          let localDataSource = localDataSource,
//          let remoteDataSource = remoteDataSource else {
//      return nil
//    }
//
//    return ConfigurationRepositoryImpl<Model, RemoteDataSource, LocalDataSource>(
//      fallback: fallback,
//      local: localDataSource,
//      remote: remoteDataSource
//    )
//  }
//}
