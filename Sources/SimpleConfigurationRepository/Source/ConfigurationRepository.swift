import Foundation

class ConfigurationRepositoryImpl<Model: ConfigurationModel>: ConfigurationRepository {

  let fallback: Model
  
  var current: SimpleConfigurationRepository.Result<Model> {
    do {
      return try .local(local.fetch())
    } catch {
      return .fallback(fallback, cause: error)
    }
  }
  
  private let local: any LocalDataSource<Model>
  private let remote: any RemoteDatasource<Model>
  
  init(fallback: Model,
       local: any LocalDataSource<Model>,
       remote: any RemoteDatasource<Model>) {
    self.fallback = fallback
    self.local = local
    self.remote = remote
  }
  
  func update() async throws -> SimpleConfigurationRepository.Result<Model> {
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
