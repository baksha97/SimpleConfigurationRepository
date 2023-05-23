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
    let initialConfig = SampleConfiguration()
    try dataSource.persist(initialConfig)
    let retrievedConfig = try dataSource.cache
    XCTAssertEqual(retrievedConfig, initialConfig, "Retrieved configuration should match the initial configuration")
  }
  
  func testRetrieveConfigurationWhenEmpty() {
    XCTAssertThrowsError(try dataSource.cache,
                         "Retrieving configuration when empty should throw an error") { error in
      guard case SimpleConfigurationRepository.DataSourceError.emptyCache = error else {
        XCTFail("Invalid Error Propagated.")
        return
      }
    }
  }
}
