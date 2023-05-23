import SwiftUI
import SimpleConfigurationRepository

struct SimpleRepositoryView: View {
  @StateObject var viewModel: SimpleRepositoryViewModel
  
  var body: some View {
    ScrollView {
      VStack {
        result
        Divider()
        actions
      }
      .padding()
    }
  }
  
  @ViewBuilder
  var result: some View {
    VStack(spacing: 16) {
      if let configurationResult = viewModel.state.result {
        ResultView(result: configurationResult)
      }
      
      if viewModel.state.hasResultAndError {
        Divider()
      }
      
      if let error = viewModel.state.updateError {
        ErrorView(error: error, label: "Update Error")
      }
    }
  }
  
  var actions: some View {
    HStack(spacing: 16) {
      Button(action: {
        viewModel.fetch()
      }) {
        Text("Fetch Current")
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(8)
      }
      
      Button(action: {
        viewModel.update()
      }) {
        Text("Perform Update")
          .foregroundColor(.white)
          .padding()
          .background(Color.green)
          .cornerRadius(8)
      }
    }
    .frame(maxHeight: 80)
  }
}

struct SimpleRepositoryView_Previews: PreviewProvider {
  static var previews: some View {
    SimpleRepositoryView(viewModel: .init(mode: .fileManager))
  }
}

struct ResultView<M: ConfigurationModel>: View {
  var result: SimpleConfigurationRepository.Result<M>
  
  var body: some View {
    VStack(spacing: 16) {
      switch result {
      case let .local(configuration):
        ConfigurationResultView(model: configuration, source: "Local")
        
      case let .remote(configuration, silentPersistenceFailure):
        ConfigurationResultView(model: configuration, source: "Remote")
        
        if let silentPersistenceFailure {
          ErrorView(error: silentPersistenceFailure, label: "Silent Persistence Failure Cause")
        }
        
      case let .fallback(configuration, cause):
        ConfigurationResultView(model: configuration, source: "Fallback")
        ErrorView(error: cause, label: "Fallback Cause")
      }
    }
    .padding()
  }
}

fileprivate struct ConfigurationResultView<M: SimpleConfigurationRepository.Model> : View {
  let model: M
  let source: String
  
  var body: some View {
    VStack {
      Text("Configuration Result (\(source))")
        .font(.headline)
      
      Text("Version: \(model.version)")
        .font(.subheadline)
        .foregroundColor(.secondary)
      
      Text((String(describing: model)))
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
  }
}

fileprivate struct ErrorView: View {
  let error: Error
  let label: String
  
  var body: some View {
    VStack {
      Text(label)
        .font(.headline)
      Text(String(describing: error.self))
        .font(.subheadline)
      Text(error.localizedDescription)
        .font(.subheadline)
        .foregroundColor(.red)
        .lineLimit(5)
    }
  }
}
