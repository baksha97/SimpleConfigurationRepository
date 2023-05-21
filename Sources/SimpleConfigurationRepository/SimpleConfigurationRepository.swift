import Foundation

enum SimpleConfigurationRepository {
  func build<M: ConfigurationModel>(settings: Settings<M>) -> any ConfigurationRepository<M> {
    settings.build()
  }
}

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

struct Settings<M: ConfigurationModel> {
  let fallback: M
  let local: LocalDataSourceType
  let remote: URL
  
  enum LocalDataSourceType {
    case filestorage
    case userDefaults(UserDefaults)
  }
}
