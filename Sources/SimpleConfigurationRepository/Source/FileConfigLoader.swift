import Foundation

class FileConfigCacheable<Configuration>: ConfigurationLocalDataSource where Configuration: ConfigurationModel {
  
  private var cachedConfigUrl: URL {
    get throws {
      guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        throw ConfigurationDataSourceError.missingDocumentsDirectory
      }
      return documentsUrl.appendingPathComponent("\(Configuration.exactModelIdentifier).json")
    }
  }
  
  private var cachedConfigurationData: Data {
    get throws {
      let url = try cachedConfigUrl
      do {
        let data = try Data(contentsOf: url)
        return data
      } catch {
        throw ConfigurationDataSourceError.emptyCatch(underlying: error)
      }
    }
  }
  
  func fetch() throws -> Configuration {
    try JSONDecoder().decode(Configuration.self, from: try cachedConfigurationData)
  }

  func persist(_ config: Configuration) throws {
    let encoder = JSONEncoder()
    let data = try encoder.encode(config)
    try data.write(to: try cachedConfigUrl)
  }
}
