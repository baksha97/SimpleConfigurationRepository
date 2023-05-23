import Foundation

public enum SimpleConfigurationRepository {
  
  /// Alias for the `ConfigurationModel` type.
  public typealias Model = ConfigurationModel
  
  /// Alias for the `ConfigurationRepository` type.
  public typealias Repository = ConfigurationRepository
  
  /// Builds and returns a configuration repository based on the provided settings.
  /// - Parameters:
  ///   - settings: The settings used to configure the repository.
  /// - Returns: An instance of `ConfigurationRepository` corresponding to the settings.
  public static func build<M: ConfigurationModel>(settings: Settings<M>) -> any ConfigurationRepository<M> {
    settings.build()
  }
  
  /// Settings for configuring the configuration repository.
  public struct Settings<M: ConfigurationModel> {
    public let fallback: M
    public let local: LocalStorage
    public let remote: RemoteStorage
    
    public init(fallback: M, local: LocalStorage, remote: RemoteStorage) {
      self.fallback = fallback
      self.local = local
      self.remote = remote
    }
  }
  
  /// Local Storage options for the configuration repository.
  public enum LocalStorage {
    case fileManager
    case userDefaults(UserDefaults)
  }
  
  /// Remote Storage options for the configuration repository.
  public enum RemoteStorage {
    case session(URLSession, location: URL)
  }
  
  /// Errors that can occur in the data source layer.
  public enum DataSourceError: Error {
    case missingDocumentsDirectory
    case emptyCatch(underlying: Error?)
  }
  
  /// Results that can be returned from the configuration repository.
  public enum Result<M: ConfigurationModel> {
    case local(M)
    case remote(M, silentPersistenceFailure: Error?)
    case fallback(M, cause: Error)
  }
}

extension SimpleConfigurationRepository.Result {
  /// Returns the model associated with the result.
  /// In some situations, you may override this extension property so that you can log the events on model access.
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

public protocol ConfigurationRepository<Configuration> where Configuration: ConfigurationModel {
  associatedtype Configuration
  
  var fallback: Configuration { get }
  var current: SimpleConfigurationRepository.Result<Configuration> { get }
  
  /// Updates the configuration repository.
  /// - Returns: The updated configuration result.
  func update() async throws -> SimpleConfigurationRepository.Result<Configuration>
}

public protocol ConfigurationModel: Codable & Identifiable & Equatable {
  /// Represents the version of the content within the model.
  var version: Int { get }
  
  /// Represents the identifier for the model class itself.
  static var modelIdentifier: String { get }
  
  /// Represents the version for the model contract itself.
  /// If you do not update this, we cannot identify the difference between failing to decode due to model changes versus corrupted data.
  static var modelVersion: Int { get }
}
