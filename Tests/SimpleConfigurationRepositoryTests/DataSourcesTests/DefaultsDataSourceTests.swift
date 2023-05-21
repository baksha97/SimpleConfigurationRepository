import XCTest
@testable import SimpleConfigurationRepository

class DefaultsDataSourceTests: XCTestCase {
  var storage: UserDefaults!
  var dataSource: DefaultsDataSource<SampleConfiguration>!
  
  override func setUp() {
    super.setUp()
    storage = UserDefaults(suiteName: "testDefaults")
    dataSource = DefaultsDataSource(storage: storage)
  }
  
  override func tearDown() {
    super.tearDown()
    storage.removePersistentDomain(forName: "testDefaults")
    storage = nil
    dataSource = nil
  }
  
  func testPersistAndRetrieveConfiguration() throws {
    // Given
    let initialConfig = SampleConfiguration()
    
    // When
    try dataSource.persist(initialConfig)
    
    // Then
    let retrievedConfig = try dataSource.cache
    XCTAssertEqual(retrievedConfig, initialConfig, "Retrieved configuration should match the initial configuration")
  }
  
  func testRetrieveConfigurationWhenEmpty() {
    // When/Then
    XCTAssertThrowsError(try dataSource.cache,
                         "Retrieving configuration when empty should throw an error") { error in
      guard case SimpleConfigurationRepository.DataSourceError.emptyCatch = error else {
        XCTFail("Invalid Error Propagated.")
        return
      }
    }
  }
}
