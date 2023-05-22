//
//  ContentView.swift
//  SimpleConfigurationDemo
//
//  Created by Travis Baksh on 5/22/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
  var body: some View {
    EmptyView()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
