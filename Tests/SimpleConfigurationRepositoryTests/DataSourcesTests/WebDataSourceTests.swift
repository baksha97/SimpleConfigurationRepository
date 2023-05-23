import XCTest
@testable import SimpleConfigurationRepository

fileprivate struct MockError: Error {}

final class WebDataSourceTests: XCTestCase {
  
  func testFetch() async throws {
    let model: SampleConfiguration = .stub
    let session = MockSession(result: .success(model.data))
    let url: URL = .init(string: "www.domain.com/useless-url/config.json")!
    let dataSource = WebDataSource<SampleConfiguration>(url: url, session: session)
    let actualConfig = try await dataSource.latest
    
    // Then
    XCTAssertEqual(actualConfig, model)
    XCTAssertEqual(session.lastURL, url)
  }
  
  func testFetch_onError() async throws {
    let session = MockSession(result: .failure(MockError()))
    let url: URL = .init(string: "www.domain.com/useless-url/config.json")!
    let dataSource = WebDataSource<SampleConfiguration>(url: url, session: session)
    do {
      let _ = try await dataSource.latest
      XCTFail("Expected an error")
    } catch {
      // Then
      XCTAssertTrue(error is MockError)
    }
  }
}

class MockSession: NetworkSession {
  let result: Result<Data, Error>
  var lastURL: URL? = nil
  
  init(result: Result<Data, Error>) {
    self.result = result
  }
  
  func data(from url: URL) async throws -> (Data, URLResponse) {
    lastURL = url
    return try (result.get(), URLResponse())
  }
}
