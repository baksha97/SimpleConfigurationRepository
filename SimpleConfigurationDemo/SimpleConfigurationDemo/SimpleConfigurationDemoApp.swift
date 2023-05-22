//
//  SimpleConfigurationDemoApp.swift
//  SimpleConfigurationDemo
//
//  Created by Travis Baksh on 5/22/23.
//

import SwiftUI

@main
struct SimpleConfigurationDemoApp: App {
  var body: some Scene {
    WindowGroup {
      VStack {
        Text("File Manager:")
          .bold()
        SimpleRepositoryView(viewModel: .init(mode: .fileManager))
        Divider()
        Text("User Defaults:")
          .bold()
        SimpleRepositoryView(viewModel: .init(mode: .userDefaults(.standard)))
      }
    }
  }
}
