//
//  ContentView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 02/03/24.
//

import SwiftUI

struct ContentView: View {
  
  @State private var view = CoordinatorView.allCases
  
  var body: some View {
    NavigationStack {
      List(view, id: \.title) { view in
        NavigationLink(view.title, destination: view.destinationView)
      }
      .navigationTitle("Example")
    }
  }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
