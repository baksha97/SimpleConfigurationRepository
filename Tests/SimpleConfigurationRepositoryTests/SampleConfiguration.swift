import XCTest
import SimpleConfigurationRepository

struct SampleConfiguration: ConfigurationModel {
  
  var version: Int = 1
  var id: String = UUID().uuidString
  
  static var modelIdentifier: String = "SampleConfiguration"
  static var modelVersion: Int = 1
  
  static let stub: Self = .init()
  
  var data: Data {
    try! JSONEncoder().encode(self)
  }
}
