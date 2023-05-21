import XCTest
@testable import SimpleConfigurationRepository

fileprivate struct MockError: Error {}

final class WebDataSourceTests: XCTestCase {
  
  func testFetch() async throws {
    let model: SampleConfiguration = .stub
    let session = MockSession(result: .success(model.data))
    let url: URL = .init(string: "www.mlb.com/useless-url/config.json")!
    let dataSource = WebDataSource<SampleConfiguration>(url: url, session: session)
    let actualConfig = try await dataSource.fetch()
    
    // Then
    XCTAssertEqual(actualConfig, model)
  }
  
  func testFetch_onError() async throws {
    let session = MockSession(result: .failure(MockError()))
    let url: URL = .init(string: "www.mlb.com/useless-url/config.json")!
    let dataSource = WebDataSource<SampleConfiguration>(url: url, session: session)
    do {
      let _ = try await dataSource.fetch()
      XCTFail("Expected an error")
    } catch {
      // Then
      XCTAssertTrue(error is MockError)
    }
  }
}

struct MockSession: NetworkSession {
  let result: Result<Data, Error>
  func data(from url: URL) async throws -> (Data, URLResponse) {
    try (result.get(), URLResponse())
  }
}
