import Foundation

class WebDataSource<Configuration: ConfigurationModel>: RemoteDatasource {
  let url: URL
  let session: NetworkSession
  
  var latest: Configuration {
    get async throws {
      let (data, _) = try await session.data(from: url)
      let config = try JSONDecoder().decode(Configuration.self, from: data)
      return config
    }
  }
  
  init(url: URL, session: NetworkSession) {
    self.url = url
    self.session = session
  }
}

protocol NetworkSession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {}
