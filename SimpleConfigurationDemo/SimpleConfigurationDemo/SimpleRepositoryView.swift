import SwiftUI
import SimpleConfigurationRepository

struct SimpleRepositoryView: View {
  @StateObject
  var viewModel = SimpleRepositoryViewModel()
  
  var body: some View {
    VStack {
      result
      Divider()
      actions
    }
  }
  
  @ViewBuilder
  var result: some View {
    if let configurationResult = viewModel.state.result {
      Text(String(describing: configurationResult))
    }
  }
  
  var actions: some View {
    HStack {
      Button("Fetch Current") {
        viewModel.fetch()
      }
      Divider()
      Button("Perform Update") {
        viewModel.update()
      }
    }.frame(maxHeight: 80)
  }
}


struct SimpleRepositoryView_Previews: PreviewProvider {
  static var previews: some View {
    SimpleRepositoryView()
  }
}
