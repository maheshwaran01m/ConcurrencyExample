//
//  CoordinatorView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 02/03/24.
//

import SwiftUI

enum CoordinatorView: CaseIterable {
  case image, asyncAwait, task, asyncLet
  
  var title: String {
    switch self {
    case .image: return "Image"
    case .asyncAwait: return "Async"
    case .task: return "Task"
    case .asyncLet: return "Async Let"
    }
  }
  
  @ViewBuilder
  var destinationView: some View {
    switch self {
    case .image: CustomDownloadAyncImageView()
    case .asyncAwait: CustomAsyncAwaitView()
    case .task: CustomTaskView()
    case .asyncLet: CustomAsyncLetView()
    }
  }
}
