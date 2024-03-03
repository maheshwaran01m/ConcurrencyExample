//
//  CustomAsyncPublisherView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 03/03/24.
//

import SwiftUI
import Combine

struct CustomAsyncPublisherView: View {
  
  @StateObject private var viewModel = CustomAsyncPublisherViewModel()
  
  var body: some View {
    List(viewModel.records, id: \.self) {
      Text($0)
        .bold()
    }
    .task { await viewModel.fetchRecords() }
  }
}

// MARK: - Preview

struct CustomAsyncPublisherView_Previews: PreviewProvider {
  static var previews: some View {
    CustomAsyncPublisherView()
  }
}

// MARK: - ViewModel

fileprivate class CustomAsyncPublisherViewModel: ObservableObject {
  
  @Published var records = [String]()
  
  let manager = CustomAsyncPublisherManager()
  
  private var cancelBag = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  func fetchRecords() async {
    await manager.addRecords()
  }
  
  private func addSubscribers() {
    Task {
      // combine
      /*
      await manager.$records
        .receive(on: DispatchQueue.main)
        .sink { [weak self] data in
          self?.records = data
        }
        .store(in: &cancelBag)
       */
      
      // async publishers
      for await value in await manager.$records.values {
        await MainActor.run {
          self.records = value
        }
      }
      
      await MainActor.run {
        self.records.append("Last")
      }
    }
  }
}

// MARK: - Manager

fileprivate actor CustomAsyncPublisherManager {
  
  @Published var records = [String]()
  
  func addRecords() async {
    records.append("one")
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    
    records.append("two")
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    
    records.append("three")
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    
    records.append("four")
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    
    records.append("five")
    
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    records.append("six")
  }
}
