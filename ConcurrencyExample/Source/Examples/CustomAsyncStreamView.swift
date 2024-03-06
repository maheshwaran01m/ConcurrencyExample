//
//  CustomAsyncStreamView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 03/03/24.
//

import SwiftUI

struct CustomAsyncStreamView: View {
  
  @StateObject private var viewModel = CustomAsyncStreamViewModel()
  
  var body: some View {
    Text(viewModel.currentNumber.description)
  }
}

// MARK: - Preview

struct CustomAsyncStreamView_Previews: PreviewProvider {
  static var previews: some View {
    CustomAsyncStreamView()
  }
}

// MARK: - ViewModel

fileprivate class CustomAsyncStreamViewModel: ObservableObject {
  
  @Published private(set) var currentNumber = 0
  
  init() {
    getData()
  }
  
  func getData() {
    // completion
    /*
    getCurrentValue { [weak self] item in
      self?.currentNumber = item
    }
     */
    
    // Async Stream
    Task {
      for await value in getCurrentValueUsingAsyncStream() {
        currentNumber = value
      }
    }
  }
  
  private func getCurrentValue(_ completion: @escaping (Int) -> Void) {
    let items = (1...10).map { Int($0) }
    
    for item in items {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(item)) {
        completion(item)
      }
    }
  }
  
  private func getCurrentValueUsingAsyncStream() -> AsyncStream<Int> {
    .init(Int.self) { [weak self] continuation in
      self?.getCurrentValue { value in
        continuation.yield(value)
        
        // cancel stream
        //continuation.finish()
      }
    }
  }
  
  // AsyncThrowingStream<T, Error>
}
