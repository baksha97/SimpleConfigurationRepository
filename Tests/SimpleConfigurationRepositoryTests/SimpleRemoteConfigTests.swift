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
//      let builder = Builder(fallback: Config(),
//                            remoteLocation: URL(string: "www.mlb.com")!,
//                            localSettings: .filestorage)
//      let result = builder.build()
    }
}
