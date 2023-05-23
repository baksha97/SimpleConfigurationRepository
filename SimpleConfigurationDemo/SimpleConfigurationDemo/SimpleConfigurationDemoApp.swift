import SwiftUI

enum Tab: Int, Hashable {
  case defaults = 0
  case fileManager = 1
}

@main
struct SimpleConfigurationDemoApp: App {
  @State private var selectedTab: Tab = .fileManager
  
  var body: some Scene {
    WindowGroup {
      VStack {
        Picker(selection: $selectedTab, label: Text("Tabs")) {
          Text("File Manager")
            .tag(Tab.fileManager)
          Text("User Defaults")
            .tag(Tab.defaults)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        tab
      }
    }
  }
  
  @ViewBuilder
  var tab: some View {
    switch selectedTab {
    case .fileManager:
      VStack {
        Text("File Manager:")
          .font(.title)
          .bold()
        SimpleRepositoryView(viewModel: .init(mode: .fileManager))
      }
    case .defaults:
      VStack {
        Text("User Defaults:")
          .font(.title)
          .bold()
        SimpleRepositoryView(viewModel: .init(mode: .userDefaults(.standard)))
      }
    }
  }
}
