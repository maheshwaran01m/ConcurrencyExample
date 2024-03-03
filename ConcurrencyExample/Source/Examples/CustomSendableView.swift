//
//  CustomSendableView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 03/03/24.
//

import SwiftUI

struct CustomSendableView: View {
  
  @StateObject private var viewModel = CustomSendableViewModel()
  
  var body: some View {
    Text("Sendable")
  }
}

// MARK: - Preview

struct CustomSendableView_Previews: PreviewProvider {
  static var previews: some View {
    CustomSendableView()
  }
}

// MARK: - ViewModel

fileprivate class CustomSendableViewModel: ObservableObject {
  
  let manager = CustomSendableManager()
  
  func updateCurrentUserInfo() async {
    let value = CustomSendableItem(name: "Example")
    
    await manager.updateData(value)
  }
}

// MARK: - Manager

fileprivate actor CustomSendableManager {
  
  
  func updateData(_ value: CustomSendableItem) {
    
  }
}

// MARK: - CustomSendableItem

// @unchecked means, we need to manually check the thread safe

// Senadable to check the thread safe for concurrent code

fileprivate final class CustomSendableItem: @unchecked Sendable {
  
  private var name: String
  
  private let queue = DispatchQueue(label: "com.concurrencyExample.CustomSendableItem")
  
  init(name: String) {
    self.name = name
  }
  
  // manually making tread safe
  func updateName(name: String) {
    queue.async {
      self.name = name
    }
  }
}
