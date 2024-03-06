//
//  CustomObservableView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 03/03/24.
//

import SwiftUI

@available(iOS 17.0, *)
fileprivate struct CustomObservableViewOne: View {
  
  @State private var viewModel = CustomObservableViewModel()
  
  var body: some View {
    Text(viewModel.title)
  }
}

// MARK: - Preview

struct CustomObservableView_Previews: PreviewProvider {
  static var previews: some View {
    CustomObservableView()
  }
}

struct CustomObservableView: View {
  
  var body: some View {
    if #available(iOS 17.0, *) {
      CustomObservableViewOne()
    } else {
      EmptyView()
    }
  }
}

// MARK: - ViewModel


@available(iOS 17.0, *)
@Observable fileprivate class CustomObservableViewModel {
  
  @ObservationIgnored let value = "Example"
  
  var title = "Title"
  
  init() {
    getTitle()
  }
  
  func getTitle() {
    Task { @MainActor in
      
      title = await updateTitle()
    }
  }
  
  func updateTitle() async -> String {
    "Example"
  }
}
