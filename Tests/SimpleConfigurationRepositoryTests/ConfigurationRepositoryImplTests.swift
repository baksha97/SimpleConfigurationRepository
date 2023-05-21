import XCTest
@testable import SimpleConfigurationRepository


fileprivate struct MockError: Error {}

class ConfigurationRepositoryImplTests: XCTestCase {
  
  let configurationModel: SampleConfiguration = .stub
  
  func testCurrentReturnsLocalCacheWhenAvailable() {
    let localDataSource = MockLocalDataSource<SampleConfiguration>(mockCache: configurationModel, error: nil)
    let repository = ConfigurationRepositoryImpl(
      fallback: configurationModel,
      local: localDataSource,
      remote: MockRemoteDatasource<SampleConfiguration>(model: nil, error: nil) // no op
    )
    
    let result = repository.current
    
    switch result {
    case .local(let model):
      XCTAssertEqual(model, configurationModel)
    default:
      XCTFail("Expected local model, got something else")
    }
  }

  func testCurrentReturnsFallbackWhenCacheThrowsError() {
    let localDataSource = MockLocalDataSource<SampleConfiguration>(mockCache: configurationModel, error: MockError())
    let repository = ConfigurationRepositoryImpl(
      fallback: configurationModel,
      local: localDataSource,
      remote: MockRemoteDatasource<SampleConfiguration>(model: nil, error: nil) // no op
    )

    let result = repository.current

    switch result {
    case .fallback(let model, let error):
      XCTAssertEqual(model, configurationModel)
      XCTAssertTrue(error is MockError)
    default:
      XCTFail("Expected fallback model, got something else")
    }
  }

  func testUpdateReturnsRemoteModel() async throws {
    let remoteDataSource = MockRemoteDatasource(model: configurationModel, error: nil)

    let repository = ConfigurationRepositoryImpl(
      fallback: configurationModel,
      local: MockLocalDataSource<SampleConfiguration>(mockCache: configurationModel, error: nil), // no op
      remote: remoteDataSource
    )

    let result = try await repository.update()

    switch result {
    case .remote(let model, _):
      XCTAssertEqual(model, configurationModel)
    default:
      XCTFail("Expected remote model, got something else")
    }
  }

  func testUpdateReturnsPersistenceError() async throws {
    let remoteDataSource = MockRemoteDatasource(model: configurationModel, error: nil)
    let localDataSource = MockLocalDataSource<SampleConfiguration>(mockCache: configurationModel, error: MockError())

    let repository = ConfigurationRepositoryImpl(
      fallback: configurationModel,
      local: localDataSource,
      remote: remoteDataSource
    )

    let result = try await repository.update()

    switch result {
    case .remote(let model, let persistenceError):
      XCTAssertEqual(model, configurationModel)
      XCTAssertTrue(persistenceError is MockError)
    default:
      XCTFail("Expected remote model, got something else")
    }
  }
}

// MARK: - MockLocalDataSource
struct MockLocalDataSource<Model: ConfigurationModel>: LocalDataSource {
  let mockCache: Model
  var cache: Model {
    get throws {
      if let error {
        throw error
      }
      return mockCache
    }
  }
  let error: Error?
  
  func persist(_ model: Model) throws {
    if let error {
      throw error
    }
  }
}

// MARK: - MockRemoteDatasource
struct MockRemoteDatasource<Model: ConfigurationModel>: RemoteDatasource {
  var url: URL { fatalError() }
  let model: Model?
  let error: Error?
  
  func fetch() async throws -> Model {
    if let error {
      throw error
    }
    return model!
  }
}
         

                                                                                                                                  
                                                                                                                                  
                                                                                                                                  
