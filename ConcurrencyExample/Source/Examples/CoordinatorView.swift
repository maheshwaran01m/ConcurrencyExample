//
//  CoordinatorView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 02/03/24.
//

import SwiftUI

enum CoordinatorView: CaseIterable {
  case image, asyncAwait, asyncLet, task, taskGroup, continuation, actor, globalActor,
       sendable, asyncPublisher, reference
  
  var title: String {
    switch self {
    case .image: return "Image"
    case .asyncAwait: return "Async"
    case .task: return "Task"
    case .asyncLet: return "Async Let"
    case .taskGroup: return "Task Group"
    case .continuation: return "Continuation"
    case .actor: return "Actor"
    case .globalActor: return "Global Actor"
    case .sendable: return "Sendable"
    case .asyncPublisher: return "Async Publisher"
    case .reference: return "Reference"
    }
  }
  
  @ViewBuilder
  var destinationView: some View {
    switch self {
    case .image: CustomDownloadAyncImageView()
    case .asyncAwait: CustomAsyncAwaitView()
    case .task: CustomTaskView()
    case .asyncLet: CustomAsyncLetView()
    case .taskGroup: CustomTaskGroupView()
    case .continuation: CustomContinuationView()
    case .actor: CustomActorView()
    case .globalActor: CustomGlobalActorView()
    case .sendable: CustomSendableView()
    case .asyncPublisher: CustomAsyncPublisherView()
    case .reference: CustomReferenceView()
    }
  }
}
