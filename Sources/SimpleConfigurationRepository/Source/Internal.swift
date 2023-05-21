import Foundation

extension ConfigurationModel {
  static var exactModelIdentifier: String {
    "\(identifier)_\(version)"
  }
}

protocol ConfigurationLocalDataSource {
  associatedtype Configuration: ConfigurationModel
  func fetch() throws -> Configuration
  func persist(_ config: Configuration) throws
}

protocol ConfigurationRemoteDatasource {
  associatedtype Configuration: ConfigurationModel
  var url: URL { get }
  func fetch() async throws -> Configuration
}
