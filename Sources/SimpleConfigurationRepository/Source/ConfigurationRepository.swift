import Foundation

class ConfigurationRepositoryImpl<Model: ConfigurationModel>: ConfigurationRepository {

  let fallback: Model
  
  var current: ConfigurationResult<Model> {
    do {
      return try .local(local.fetch())
    } catch {
      return .fallback(fallback, cause: error)
    }
  }
  
  private let local: any ConfigurationLocalDataSource<Model>
  private let remote: any ConfigurationRemoteDatasource<Model>
  
  init(fallback: Model,
       local: any ConfigurationLocalDataSource<Model>,
       remote: any ConfigurationRemoteDatasource<Model>) {
    self.fallback = fallback
    self.local = local
    self.remote = remote
  }
  
  func update() async throws -> ConfigurationResult<Model> {
    let update = try await remote.fetch()
    var persistenceError: Error? = nil
    do {
      try local.persist(update)
    } catch {
      persistenceError = error
    }
    return .remote(update, silentPersistenceFailure: persistenceError)
  }
}
