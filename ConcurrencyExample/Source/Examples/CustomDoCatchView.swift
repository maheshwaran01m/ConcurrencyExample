//
//  CustomDoCatchView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 02/03/24.
//

import SwiftUI

struct CustomDoCatchView: View {
  
  @StateObject private var viewModel = CustomDoCatchViewModel()
  
  var body: some View {
    Text(viewModel.text)
      .padding()
      .background(Color.blue.opacity(0.2), in: Capsule())
      .onTapGesture(perform: viewModel.fetchTitle)
  }
}

// MARK: - Preview

struct CustomDoCatchView_Previews: PreviewProvider {
  static var previews: some View {
    CustomDoCatchView()
  }
}

// MARK: - ViewModel

fileprivate class CustomDoCatchViewModel: ObservableObject {
  
  @Published var text = "Starting text..."
  
  let manager: CustomDoCatchManager
  
  init(manager: CustomDoCatchManager = .init()) {
    self.manager = manager
  }
  
  func fetchTitle() {
  /*
   switch manager.getTitle() {
   case .success(let value):
     text = value
   case .failure(let error):
     text = error.localizedDescription
   }
   */
    
    do {
      text = try manager.getTitleOne()
    } catch {
      text = error.localizedDescription
    }
  }
}

// MARK: - Mock Manager

fileprivate class CustomDoCatchManager {
  
  var isActive = Bool.random()
  
  func getTitle() -> Result<String, Error> {
    return isActive ? .success("New Text") : .failure(URLError(.badURL))
  }
  
  func getTitleOne() throws -> String {
    if isActive {
      return "New Text"
    }
    throw URLError(.badServerResponse)
  }
}
