//
//  CustomAsyncAwaitView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 02/03/24.
//

import SwiftUI

struct CustomAsyncAwaitView: View {
  
  @StateObject private var viewModel = CustomAsyncAwaitViewModel()
  
  var body: some View {
    List(viewModel.records, id: \.self) { record in
      Text(record)
    }
    .navigationBarTitleDisplayMode(.inline)
  }
}

// MARK: - Preview

struct CustomAsyncAwaitView_Previews: PreviewProvider {
  static var previews: some View {
    CustomAsyncAwaitView()
  }
}

// MARK: -

fileprivate class CustomAsyncAwaitViewModel: ObservableObject {
  
  @Published var records = [String]()
  
  init() {
    fetchRecords()
  }
  
  func fetchRecords() {
//    getRecords()
//    getBackgroundRecords()
    
    Task {
      await exampleRecords()
    }
  }
  
  func getRecords() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.records.append("Value 1: \(Thread.current.description)")
    }
  }
  
  func getBackgroundRecords() {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
      let title = Thread.current.description
      
      DispatchQueue.main.async {
        self.records.append("Value 2: \(title)")
      }
    }
  }
  
  // MARK: - Async
  
  func exampleRecords() async {
//    let value = "Value: \(Thread.current)"
    
    self.records.append("Value 1")
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    
    await MainActor.run {
      self.records.append("Value 2")
    }
    
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    
    await MainActor.run {
      self.records.append("Value 3")
    }
  }
}
