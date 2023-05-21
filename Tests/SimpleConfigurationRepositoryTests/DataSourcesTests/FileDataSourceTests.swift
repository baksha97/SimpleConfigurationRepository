import XCTest
@testable import SimpleConfigurationRepository

class FileDataSourceTests: XCTestCase {
  
  var dataSource: FileDataSource<SampleConfiguration>!
  
  override func setUp() {
    dataSource = .init()
    try? FileManager.default.removeItem(at: dataSource.cachedConfigUrl)
  }
  
  func testCachedConfigUrlIsJsonSuffix() throws {
    XCTAssertTrue(try dataSource.cachedConfigUrl.lastPathComponent.hasSuffix(".json"))
  }
  
  func testPersistAndFetch() throws {
    let dataSource = FileDataSource<SampleConfiguration>()
    let testConfig: SampleConfiguration = .stub
    try dataSource.persist(testConfig)
    let cachedConfig = try dataSource.cache
    XCTAssertEqual(cachedConfig, testConfig)
  }
  
  func testRetrieveConfigurationWhenEmpty() {
    let dataSource = FileDataSource<SampleConfiguration>()
    XCTAssertThrowsError(try dataSource.cache,
                         "Retrieving configuration when empty should throw an error") { error in
      guard case SimpleConfigurationRepository.DataSourceError.emptyCatch(let underlying) = error, let underlyingNSError = underlying as? NSError else {
        XCTFail("Invalid Error Propagated.")
        return
      }
      print(underlyingNSError)
      XCTAssertEqual(underlyingNSError.domain, "NSCocoaErrorDomain")
      XCTAssertEqual(underlyingNSError.code, 260)
    }
  }
  
  func testPersistWithExistingCacheAndFetch() throws {
    let dataSource = FileDataSource<SampleConfiguration>()
    let initialTestConfiguration: SampleConfiguration = .stub
    try dataSource.persist(initialTestConfiguration)
    // update cache
    var newConfiguration: SampleConfiguration = .stub
    newConfiguration.version = 2
    try dataSource.persist(newConfiguration)
    
    let cachedConfiguration = try dataSource.cache
    
    XCTAssertNotEqual(cachedConfiguration, initialTestConfiguration)
    XCTAssertEqual(cachedConfiguration.version, 2)
  }
}
