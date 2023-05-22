//
//  SimpleRepositoryView.swift
//  SimpleConfigurationDemo
//
//  Created by Travis Baksh on 5/22/23.
//

import SwiftUI
import SimpleConfigurationRepository

struct MySimpleConfig: SimpleConfigurationRepository.Model {
  var id: Int { version }
  let version: Int
  let value: String
  static var modelIdentifier: String = "MySimpleConfig"
  static var modelVersion: Int = 1
}

struct SimpleRepositoryView: View {
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

struct SimpleRepositoryView_Previews: PreviewProvider {
  static var previews: some View {
    SimpleRepositoryView()
  }
}


@MainActor
class SimpleRepostioryViewModel: ObservableObject {
  @Published var configuration: MySimpleConfig
  
  private let repository: any ConfigurationRepository<MySimpleConfig>
  init() {
    let fallback = MySimpleConfig(version: 1, value: "Fallback")
    configuration = fallback
    repository = SimpleConfigurationRepository.build(
      settings: .init(
        fallback: fallback,
        mode: .fileManager,
        location: .init(string: "")!
      )
    )
  }
}
