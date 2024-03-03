//
//  CustomGlobalActorView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 03/03/24.
//

import SwiftUI

struct CustomGlobalActorView: View {
  
  @StateObject private var viewModel = CustomGlobalActorViewModel()
  
  var body: some View {
    
    List(viewModel.records, id: \.self) { record in
      Text(record.capitalized)
    }
    .task { await viewModel.getRecords() }
  }
}

// MARK: - Preview

struct CustomGlobalActorView_Previews: PreviewProvider {
  static var previews: some View {
    CustomGlobalActorView()
  }
}

// MARK: - CustomGlobalActorViewModel

//@MainActor // mark entire class the mainActor
fileprivate class CustomGlobalActorViewModel: ObservableObject {
  
 @MainActor @Published var records = [String]()

  let manager = CustomGlobalActorManager()
  
  // To access nonisolated values, using shared instance
  @CustomGlobalActorDataManager func getRecords() {
    Task {
      let data = await manager.getData()
      
      await MainActor.run {
        records = data
      }
    }
  }
  
  @MainActor func getRecordsInMainThread() {
    
  }
}

// MARK: - CustomGlobalActorManager


fileprivate actor CustomGlobalActorManager {
  
  func getData() -> [String] {
    return ["one", "two", "three", "four"]
  }
}

// MARK: - GlobalActor

@globalActor fileprivate final class CustomGlobalActorDataManager {
  
  static var shared = CustomGlobalActorManager()
}
