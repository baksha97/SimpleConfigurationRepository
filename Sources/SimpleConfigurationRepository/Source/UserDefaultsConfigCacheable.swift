import Foundation

class UserDefaultsConfigCacheable<Configuration: ConfigurationModel>: ConfigurationLocalDataSource {
  let storage: UserDefaults
  
  init(storage: UserDefaults) {
    self.storage = storage
  }
  
  func fetch() throws -> Configuration {
    guard let configData = storage.object(forKey: Configuration.identifier) as? Data else {
      throw ConfigurationDataSourceError.emptyCatch(underlying: nil)
    }
    return try JSONDecoder().decode(Configuration.self, from: configData)
  }
  
  func persist(_ config: Configuration) throws {
    let data = try JSONEncoder().encode(config)
    storage.set(data, forKey: Configuration.identifier)
  }
}
