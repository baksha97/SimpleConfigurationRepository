import Foundation

public enum SimpleConfigurationRepository {
  
  typealias Model = ConfigurationModel
  typealias Repository = ConfigurationRepository
  
  public func build<M: ConfigurationModel>(settings: Settings<M>) -> any ConfigurationRepository<M> {
    settings.build()
  }
  
  public struct Settings<M: ConfigurationModel> {
    public let fallback: M
    public let mode: Storage
    public let location: URL
    
    public enum Storage {
      case fileManager
      case userDefaults(UserDefaults)
    }
  }
  
  public enum DataSourceError: Error {
    case missingDocumentsDirectory
    case emptyCatch(underlying: Error?)
  }
  
  public enum Result<M: ConfigurationModel> {
    case local(M)
    case remote(M, silentPersistenceFailure: Error?)
    case fallback(M, cause: Error)
    
    var model: M {
      switch self {
      case .local(let value):
        return value
      case .remote(let value, _):
        return value
      case .fallback(let value, _):
        return value
      }
    }
  }
}

public protocol ConfigurationRepository<Configuration> where Configuration: ConfigurationModel {
  associatedtype Configuration
  
  var fallback: Configuration { get }
  var current: SimpleConfigurationRepository.Result<Configuration> { get }
  
  func update() async throws -> SimpleConfigurationRepository.Result<Configuration>
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
