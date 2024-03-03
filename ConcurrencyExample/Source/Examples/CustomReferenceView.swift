//
//  CustomReferenceView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 03/03/24.
//

import SwiftUI

struct CustomReferenceView: View {
  
  @StateObject private var viewModel = CustomReferenceViewModel()
  
  var body: some View {
    VStack {
      Text(viewModel.text)
    }
  }
}

// MARK: - Preview

struct CustomReferenceView_Previews: PreviewProvider {
  static var previews: some View {
    CustomReferenceView()
  }
}

// MARK: - ViewModel

fileprivate class CustomReferenceViewModel: ObservableObject {
  
  @Published var text = "Some Title"
  
  private var task: Task<(), Never>?
  
  init() {
    fetchRecords()
  }
  
  func fetchRecords() {
    Task {
      text = await getData()
    }
    
    // not required to make weak reference
    task = Task { [weak self] in
      if let data = await self?.getData() {
        self?.text = data
      }
    }
    
    // task will run in main actor
    task = Task { @MainActor in
      text = await getData()
    }
  }
  
  func getData() async -> String {
    "Updated value"
  }
  
  deinit {
    task?.cancel()
    task = nil
  }
}
