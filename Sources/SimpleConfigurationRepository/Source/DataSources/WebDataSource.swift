import Foundation

class WebDataSource<Configuration: ConfigurationModel>: RemoteDatasource {
  let url: URL
  let session: NetworkSession
  init(url: URL, session: NetworkSession = URLSession.shared) {
    self.url = url
    self.session = session
  }
  
  func fetch() async throws -> Configuration {
    let (data, _) = try await session.data(from: url)
    let config = try JSONDecoder().decode(Configuration.self, from: data)
    return config
  }
}

protocol NetworkSession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {}
