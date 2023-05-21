import Foundation

class DefaultsDataSource<Configuration: ConfigurationModel>: LocalDataSource {
  let storage: UserDefaults
  
  var cache: Configuration  {
    get throws {
      guard let configData = storage.object(forKey: Configuration.modelIdentifier) as? Data else {
        throw SimpleConfigurationRepository.DataSourceError.emptyCatch(underlying: nil)
      }
      return try JSONDecoder().decode(Configuration.self, from: configData)
    }
  }
  
  init(storage: UserDefaults) {
    self.storage = storage
  }
  
  func persist(_ config: Configuration) throws {
    let data = try JSONEncoder().encode(config)
    storage.set(data, forKey: Configuration.modelIdentifier)
  }
}
