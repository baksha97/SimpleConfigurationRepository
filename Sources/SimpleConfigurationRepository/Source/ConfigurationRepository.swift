import Foundation

class ConfigurationRepositoryImpl<
  Model: ConfigurationModel,
  RemoteDataSource: ConfigurationRemoteDatasource,
  LocalDataSource: ConfigurationLocalDataSource
>: ConfigurationRepository where RemoteDataSource.Configuration == Model,
                                 LocalDataSource.Configuration == Model {

  let fallback: Model
  
  var current: ConfigurationResult<Model> {
    do {
      return try .local(local.fetch())
    } catch {
      return .fallback(fallback, cause: error)
    }
  }
  
  private let local: LocalDataSource
  private let remote: RemoteDataSource
  
  init(fallback: Model,
       local: LocalDataSource,
       remote: RemoteDataSource) {
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
