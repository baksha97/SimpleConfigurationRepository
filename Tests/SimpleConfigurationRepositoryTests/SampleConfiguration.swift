import XCTest
import SimpleConfigurationRepository

struct SampleConfiguration: ConfigurationModel {
  var version: Int = 1
  var id: String = UUID().uuidString
  
  static var identifier: String = "SampleConfiguration"
  static var version: Int = 1
  
  static let stub: Self = .init()
  
  var data: Data {
    try! JSONEncoder().encode(self)
  }
}
