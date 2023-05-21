import Foundation

class RemoteConfigFetcher<Configuration: ConfigurationModel>: ConfigurationRemoteDatasource {
  let url: URL
  
  init(url: URL) {
    self.url = url
  }
  
  func fetch() async throws -> Configuration {
    let (data, _) = try await URLSession.shared.data(from: url)
    let config = try JSONDecoder().decode(Configuration.self, from: data)
    return config
  }
}
