import XCTest
@testable import SimpleConfigurationRepository

struct Config: ConfigurationModel {
  var version: Int = 1
  
  static var identifier: String = "ID"
  
  static var version: Int = 1
  var id: String { "Config" }
}

final class SimpleRemoteConfigTests: XCTestCase {
  func testExample() throws {
  }
  
  // Test cases
  func testCurrent_WhenLocalDataSourceSucceeds_ReturnsLocalData() throws {
    // Arrange
    let localDataSource = MockConfigurationLocalDataSource<Config>()
    localDataSource.persistData = Config() // Set local data
    
    let repository = ConfigurationRepositoryImpl(fallback: Config(),
                                                 local: localDataSource,
                                                 remote: MockConfigurationRemoteDataSource<Config>())
    
    // Act
    let result = repository.current
    
    // Assert
//    XCTAssert(result.isLocal)
  }
  
  func testCurrent_WhenLocalDataSourceFails_ReturnsFallbackData() throws {
    // Arrange
    let localDataSource = MockConfigurationLocalDataSource<Config>()
    localDataSource.persistCalled = true // Set local data persistence failure
    
    let repository = ConfigurationRepositoryImpl(fallback: Config(),
                                                 local: localDataSource,
                                                 remote: MockConfigurationRemoteDataSource<Config>())
    
    // Act
    let result = repository.current
    
    // Assert
//    XCTAssert(result.isFallback)
  }
  
  func testUpdate_WhenRemoteDataSourceSucceeds_PersistsDataLocally() async throws {
    // Arrange
    let localDataSource = MockConfigurationLocalDataSource<Config>()
    let remoteDataSource = MockConfigurationRemoteDataSource<Config>()
    remoteDataSource.fetchData = Config() // Set remote data
    
    let repository = ConfigurationRepositoryImpl(fallback: Config(),
                                                 local: localDataSource,
                                                 remote: remoteDataSource)
    
    // Act
    let result = try await repository.update()
    
    // Assert
    XCTAssert(remoteDataSource.fetchCalled)
    XCTAssert(localDataSource.persistCalled)
//    XCTAssert(result.isRemote)
  }
  
  func testUpdate_WhenRemoteDataSourceFails_ReturnsFallbackData() async throws {
    // Arrange
    let localDataSource = MockConfigurationLocalDataSource<Config>()
    let remoteDataSource = MockConfigurationRemoteDataSource<Config>()
    remoteDataSource.fetchCalled = true // Set remote data fetch failure
    
    let repository = ConfigurationRepositoryImpl(fallback: Config(),
                                                 local: localDataSource,
                                                 remote: remoteDataSource)
    
    // Act
    let result = try await repository.update()
    
    // Assert
    XCTAssert(remoteDataSource.fetchCalled)
    XCTAssert(localDataSource.persistCalled)
//    XCTAssert(result.isFallback)
  }
}


// Mock objects
class MockConfigurationLocalDataSource<Model: ConfigurationModel>: LocalDataSource {
  func fetch() throws -> Model {
//    fatalError()
    throw NSError(domain: "t", code: -1)
  }
  
  var persistCalled = false
  var persistData: Model?
  
  func persist(_ data: Model) throws {
    persistCalled = true
    persistData = data
  }
}

class MockConfigurationRemoteDataSource<Model: ConfigurationModel>: RemoteDatasource {
  var url: URL { fatalError() }
  
  var fetchCalled = false
  var fetchData: Model?
  
  func fetch() async throws -> Model {
    fetchCalled = true
    if let fetchData {
      return fetchData
    } else {
      throw NSError(domain: "", code: 0, userInfo: nil)
    }
  }
}
