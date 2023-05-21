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

public protocol ConfigurationRepository {
  associatedtype Configuration: ConfigurationModel
  
  var fallback: Configuration { get }
  var current: ConfigurationResult<Configuration> { get }
  
  func update() async throws -> ConfigurationResult<Configuration>
}

enum Settings {
  enum LocalDataSourceType {
    case filestorage
    case userDefaults(UserDefaults)
  }
}

internal struct Builder<
  Model: ConfigurationModel,
  Repository: ConfigurationRepository> where Repository.Configuration == Model {
  
  let fallback: Model
  let remoteLocation: URL
  let localSettings: Settings.LocalDataSourceType

  
  func build() -> Repository {
    ConfigurationRepositoryImpl<Model, RemoteConfigFetcher<Model>, FileConfigCacheable<Model>>(
      fallback: fallback,
      local: FileConfigCacheable<Model>(),
      remote: RemoteConfigFetcher<Model>(url: remoteLocation)
    )
  }
  
}
